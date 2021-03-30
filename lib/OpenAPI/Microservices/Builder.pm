package OpenAPI::Microservices::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use Mojo::File qw(path);
use Mojo::JSON 'decode_json';
use JSON::Validator::Schema::OpenAPIv3;

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder::Package;

use OpenAPI::Microservices::Utils::Core qw(
  resolve_method
);
use OpenAPI::Microservices::Utils::Types qw(
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
    isa     => HashRef [ InstanceOf ['OpenAPI::Microservices::Builder::Package'] ],
    default => sub { {} },
);

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
            my $http_method  = $route->{method};
            my $operation_id = $route->{operation_id};
            my $path         = $route->{path};
            my $description
              = $schema->get(  [ "paths", $path, $http_method, "description" ] )
              || $schema->get( [ "paths", $path, $http_method, "summary" ] )
              || 'No description found';
            my ( $package_name, $method_name, $args ) = resolve_method(
                $base,
                $http_method,
                $path,
            );
            my $package = $self->packages->{$package_name} //= OpenAPI::Microservices::Builder::Package->new( name => $package_name, base => $base );
            $package->add_method(
                http_method => $http_method,
                path        => $path,
                description => $description,
            );
            $self->_write_package($package);
        }
    );
    $self->_write_driver;
}

sub _write_package {
    my ( $self, $package ) = @_;
    my $package_name = $package->name;

    my ( $base, $filename );
    if ( $package_name =~ /^(?<path>.*::)(?<file>.*)$/ ) {
        $base     = $+{path};
        $filename = $+{file};
        $base =~ s{::}{/}g;
    }
    else {
        croak("Bad package name: $package_name");
    }

    $filename .= ".pm";
    my $path = path( $self->dir . "/lib/$base" )->make_path;
    $path->make_path->child($filename)->spurt( $package->to_string );
}

sub _write_driver {
    my $self = shift;

    my $code = <<'END';
#!/usr/bin/env perl

use strict;
use warnings;
use Scalar::Util 'blessed';
use lib '../lib'; # XXX fix me (load OpenAPI::Microservices::*)

use Plack::Request;
use OpenAPI::Microservices::App::Router;

END

    my $routes   = '';
    my @packages = map { $_->name } values %{ $self->packages };
    foreach my $package (@packages) {
        $code   .= "use $package;\n";
        $routes .= "\$router->add_route(\$_) foreach $package->routes;\n";
    }
    $code .= <<"END";

my \$router = OpenAPI::Microservices::App::Router->new;
$routes

END
    $code .= <<'END';
sub {
    my $req   = Plack::Request->new(shift);
    my $match = $router->match($req)
        or return $req->new_response(404)->finalize;

    my $controller = $match->{controller};
    my $action = $controller->can($match->{action})
        or return $req->new_response(405)->finalize;
    my $res;
    if ( eval { $res = $controller->$action($req, $match); 1 } ) {
        $res->finalize;
    }
    else {
        my $error = $@;
        my $res;
        if ( blessed $error ) {
            $res = $req->new_response($error->status_code);
            if ( my $info = $error->info ) {
                $res->content_type('text/plain');
                $res->body($info);
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
