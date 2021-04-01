package Net::OpenAPI::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use Mojo::File qw(path);
use Mojo::JSON qw(decode_json encode_json);
use JSON::Validator::Schema::OpenAPIv3;

use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder::Package;

use Net::OpenAPI::Utils::Core qw(
  resolve_root
);
use Net::OpenAPI::App::Types qw(
  Directory
  HashRef
  InstanceOf
  NonEmptyStr
  PackageName
);
use namespace::autoclean;

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has _schema => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
    init_arg => 'schema',
);

has _validator => (
    is      => 'lazy',
    isa     => InstanceOf ['JSON::Validator::Schema::OpenAPIv3'],
    builder => sub {
        my $self = shift;
        my $file = Mojo::File->new( $self->_schema );
        return JSON::Validator::Schema::OpenAPIv3->new( decode_json( $file->slurp ) );
    },
);

has dir => (
    is       => 'ro',
    isa      => Directory,
    required => 1,
);

has packages => (
    is      => 'ro',
    isa     => HashRef [ InstanceOf ['Net::OpenAPI::Builder::Package'] ],
    default => sub { {} },
);

sub _get_packages {
    my $self = shift;
    return values %{ $self->packages };
}

sub write {
    my $self   = shift;
    my $schema = $self->_validator->schema;

    if ( my @errors = $schema->errors->@* ) {
        my $errors = join "\n" => @errors;
        croak($errors);
    }

    my $routes = $schema->routes;
    my $base   = $self->base;
    $routes->each(
        sub {
            my ( $route, $num ) = @_;
            my $http_method = $route->{method};
            my $path        = $route->{path};
            my $description
              = $schema->get(  [ "paths", $path, $http_method, "description" ] )
              || $schema->get( [ "paths", $path, $http_method, "summary" ] )
              || 'No description found';
            my $root    = resolve_root($path);
            my $package = $self->packages->{$root} //= Net::OpenAPI::Builder::Package->new( base => $base, root => $root );
            $package->add_method(
                http_method => $http_method,
                path        => $path,
                description => $description,
            );
        }
    );
    $_->write( $self->dir ) foreach $self->_get_packages;
    $self->_write_driver;
}

sub _write_driver {
    my $self = shift;

    my $code = <<'END';
#!/usr/bin/env perl

use strict;
use warnings;
use Scalar::Util 'blessed';
use Mojo::JSON qw(encode_json);
use lib '../lib'; # XXX fix me (load Net::OpenAPI::*)

use Plack::Request;
use Net::OpenAPI::App::Router;

END

    my $routes   = '';
    my @packages = map { $_->controller_name } values %{ $self->packages };
    foreach my $package (@packages) {
        $code   .= "use $package;\n";
        $routes .= "\$router->add_route(\$_) foreach $package->routes;\n";
    }
    $code .= <<"END";

my \$router = Net::OpenAPI::App::Router->new;
$routes

END
    $code .= <<'END';
sub {
    my $req   = Plack::Request->new(shift);
    my $match = $router->match($req)
      or return $req->new_response(404)->finalize;

    my $dispatcher = $match->{dispatch};
    my $res = $req->new_response(200);
    $res->content_type('application/json');
    my $result;
    if ( eval { $result = $dispatcher->( $req, $match->{uri_params} ); 1 } ) {
        $res->body(encode_json($result));
        $res->finalize;
    }
    else {
        my $error = $@;
        my $res;
        if ( blessed $error && $error->isa('Net::OpenAPI::Exceptions::Base') ) {
            $res = $req->new_response( $error->status_code );
            if ( my $info = $error->info ) {
                $res->content_type('application/json');
                $res->body(
                    encode_json(
                        {
                            info    => $info,
                            code    => $error->status_code,
                            message => $error->message,
                        }
                    )
                );
            }
        }
        else {
            $res = $req->new_response(500);
        }
        $res->finalize;
    }
};

END
    my $path = path( $self->dir . "/script" )->make_path;
    $path->make_path->child('app.psgi')->spurt($code);
}
1;