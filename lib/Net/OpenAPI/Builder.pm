package Net::OpenAPI::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use File::Path qw(make_path);
use File::Spec::Functions qw(splitpath catdir);

use Net::OpenAPI::App::JSON qw(decode_json);
use Net::OpenAPI::App::Validator;
use Net::OpenAPI::Builder::Controller;
use Net::OpenAPI::Builder::Docs;
use Net::OpenAPI::Builder::Endpoint;
use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::File qw(slurp write_file);
use Net::OpenAPI::Utils::Template qw(template);

use Net::OpenAPI::Utils::Core qw(
  get_path_and_filename
  resolve_root
  tidy_code
  unindent
);
use Net::OpenAPI::App::Types qw(
  ArrayRef
  Directory
  HashRef
  InstanceOf
  NonEmptyStr
  OpenAPIPath
  PackageName
);
use namespace::autoclean;

=head1 PARAMETERS

=head2 base

Base package name for generated code

=cut

our $VERSION = '0.01';

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

=head2 schema_file

Filename for OpenAPI schema

=cut

has schema_file => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

=head2 dir

Directory for generated code

=cut

# The File::Temp::Dir is for tests
has dir => (
    is       => 'ro',
    isa      => Directory | InstanceOf ['File::Temp::Dir'],
    required => 1,
);

=head2 api_base

Base path for openapi directories. (e.g., C</api/v1>);

=cut

has api_base => (
    is       => 'ro',
    isa      => OpenAPIPath,
    required => 1,
);

=head2 doc_base

Base path for openapi documentation. (e.g., C</api/docs>);

=cut

has doc_base => (
    is       => 'ro',
    isa      => OpenAPIPath,
    required => 1,
);

=head1 ATTRIBUTES

=head2 app

Package name for generated App

=cut

has app => (
    is      => 'lazy',
    isa     => PackageName,
    builder => sub {
        my $self = shift;
        return $self->base . '::App';
    },
);

=head2 raw_schema

Unvalidated schema, as read from L</schema_file>

=cut

has raw_schema => (
    is      => 'lazy',
    isa     => HashRef,
    builder => sub {
        my $self = shift;
        return decode_json( slurp( $self->schema_file ) );
    },
);

=head1 validator

Instance of L<JSON::Validator::Schema::OpenAPIv3>

NOTE: Currently, request/response validation requires a full C<validator> instance,
so generated application includes a copy of L</schema_file> and re-generates the
C<validator> on startup.

=head1 schema_errors

Delegated to L</validator>

=cut

has validator => (
    is      => 'lazy',
    isa     => InstanceOf ['Net::OpenAPI::App::Validator'],
    builder => sub {
        my $self = shift;
        return Net::OpenAPI::App::Validator->new( raw_schema => $self->raw_schema );
    },
    handles => { schema => 'schema', schema_errors => 'errors' },
);

=head1 endpoints

All endpoints defined by L</schema>, as L</Net::OpenAPI::Builder::Endpoint> instances

=cut

has endpoints => (
    is      => 'lazy',
    isa     => ArrayRef [ InstanceOf ['Net::OpenAPI::Builder::Endpoint'] ],
    builder => sub {
        my $self = shift;
        return [ map { Net::OpenAPI::Builder::Endpoint->new( validator => $self->validator, route => $_ ) } @{ $self->schema->routes } ];
    },
);

has docs => (
    is      => 'lazy',
    isa     => InstanceOf ['Net::OpenAPI::Builder::Docs'],
    builder => sub {
        my $self = shift;
        return Net::OpenAPI::Builder::Docs->new(
            schema_file => $self->schema_file,
            base        => $self->base,
            path        => $self->doc_base,
        );
    },
);

=head2 endpoints_by_controller

All L</endpoints> grouped by target Controller.

POLICY: L<Net::OpenAPI::Builder::Endpoint/controller_package> determines the
Controller for each endpoint.

=cut

has endpoints_by_controller => (
    is      => 'lazy',
    isa     => HashRef [ ArrayRef [ InstanceOf ['Net::OpenAPI::Builder::Endpoint'] ] ],
    builder => sub {
        my $self = shift;
        my %endpoints_by_controller;
        for my $endpoint ( @{ $self->endpoints } ) {
            my $controller_name = $endpoint->controller_name;
            push @{ $endpoints_by_controller{$controller_name} }, $endpoint;
        }
        return \%endpoints_by_controller;
    },
);

=head1 controllers

L<Net::OpenAPI::Builder::Controller> instances for all controllers in L</endpoints_by_controller>

=cut

has controllers => (
    is      => 'lazy',
    isa     => ArrayRef [ InstanceOf ['Net::OpenAPI::Builder::Controller'] ],
    builder => sub {
        my $self = shift;

        my $endpoints_by_controller = $self->endpoints_by_controller;
        return [
            map {
                Net::OpenAPI::Builder::Controller->new(
                    base      => $self->base,
                    name      => $_,
                    endpoints => $endpoints_by_controller->{$_}
                )
            } keys %$endpoints_by_controller
        ];
    },
);

=head1 METHODS

=head2 validate

Validate the specification. Dies if specification is invalid.

=cut

sub validate {
    my $self = shift;

    if ( my @errors = @{ $self->schema_errors } ) {
        croak "OpenAPI validation errors: " . join "\n" => @errors;
    }

    my $controllers = $self->controllers;
    my %controller_errors;
    for my $controller (@$controllers) {
        my $errors = $controller->errors;
        if (@$errors) {
            $controller_errors{ $controller->package } = $errors;
        }
    }

    if (%controller_errors) {
        my @lines = ('Controller errors:');
        for my $controller ( sort keys %controller_errors ) {
            my $errors = $controller_errors{$controller};
            push @lines, "    $controller:";
            for my $error (@$errors) {
                push @lines, "        $error";
            }
        }
        croak join "\n" => @lines;
    }
}

=head1 OUTPUT ATTRIBUTES

=head2 code

Code for the main App modules of this application

=cut

has code => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    builder => sub {
        my $self = shift;

        my $package = $self->app;
        my ( $path, $filename ) = get_path_and_filename( $self->dir, $package );

        my @controllers = sort map { $_->package } @{ $self->controllers };

        # the sort keeps the auto-generated code deterministic. We put short paths
        # first just because it's easier to read, but we break ties by sorting on
        # the guaranteed unique names
        my @endpoints = sort { length( $a->path ) <=> length( $b->path ) || $a->action_name cmp $b->action_name } @{ $self->endpoints };

        return template(
            name     => 'app',
            template => $self->_app_template,
            data     => {
                base        => $self->base,
                docs        => $self->docs->package,
                package     => $package,
                controllers => \@controllers,
            },
            tidy => 1,
        );
    },
);

sub _app_template {
    state $template;

    return $template //= do {
        my $template_content = unindent(<<'        EOF');
        package [% package %];
        
        [% rewrite_boundary %]
        use v5.16.0;
        use strict;
        use warnings;
        use Scalar::Util 'blessed';
        use Plack::Request;
        
        use Net::OpenAPI::App::JSON qw(encode_json);
        use Net::OpenAPI::App::Router;
        use Net::OpenAPI::App::StatusCodes qw(HTTPOK HTTPInternalServerError);
        use [% docs %];
        
        [% FOREACH controller IN controllers %]use [% controller %];
        [% END %]
        my $routes = [[% FOREACH controller IN controllers %]
            [% controller %]->routes,[% END %]
        ];

        my $router = Net::OpenAPI::App::Router->new( routes => $routes );
        
        sub get_app {
            return sub {
                my $req = Plack::Request->new(shift);
                my ( $action, $match ) = $router->match($req)
                  or return $req->new_response(404)->finalize;

                my ( $result, $res );
                if ( eval { $result = $action->( $req, $match ); 1 } ) {
                    if ( blessed $result && $result->isa('Net::OpenAPI::App::Response') ) {

                        # they've returned a response object. Use it.
                        $res = $req->new_response( $result->status_code );
                        if ( my $body = $result->body ) {
                            $res->content_type('application/json');
                            $res->body( encode_json($body) );
                        }
                    }
                    elsif ( ref $result ) {

                        # they've returned a raw data structure as a shortcut. Use it.
                        $res = $req->new_response(HTTPOK);
                        $res->content_type('application/json');
                        $res->body( encode_json($result) );
                    }
                }
                else {
                    # XXX eval failed. Need more info here.
                    warn $@;
                    $res = $req->new_response(HTTPInternalServerError);
                }
                return $res->finalize;
            };
        }

        sub doc_index {
            return sub {
                my $req = Plack::Request->new(shift);
                return [% docs %]->index($req)
            };
        }

        [% rewrite_boundary %]
        
        1;
        
        __END__
        
        =head1 NAME
        
        [% package %] - Application module for [% base %]
        
        =head1 SYNOPSIS
        
            use [% package %];
            use Net::OpenAPI::App::Router;
        
            my $router = Net::OpenAPI::App::Router->new;
            $router->add_routes([% package %]->routes)
        
        =head1 METHODS
        
        =head2 C<routes>
        
            my \$routes = [% package %]->routes;
        
        Class method. Returns an array reference of routes you can pass to
        C<&Net::OpenAPI::App::Router::add_routes>.
        EOF

        $template_content;
    };
}

=head1 OUTPUT METHODS

=head2 write

Write the application

=cut

sub write {
    my $self = shift;
    $self->validate;

    $self->_write_schema;
    $self->_write_controllers;
    $self->_write_app;
    $self->_write_docs;
    $self->_write_psgi;
}

sub _write_schema {
    my $self = shift;

    # we're will eventually need to compose multiple schema files,
    # so this won't be enough
    my $schema_file = $self->schema_file;
    my ( undef, $directories, $file ) = splitpath($schema_file);
    my $dir = catdir( $self->dir, 'openapi', $directories );
    make_path($dir);
    write_file(
        path      => $dir,
        file      => $file,
        document  => slurp( $self->schema_file ),
        overwrite => 1,
    );
}

sub _write_controllers {
    my $self = shift;

    for my $controller ( @{ $self->controllers } ) {

        my $package = $controller->package;
        my ( $path, $filename ) = get_path_and_filename( $self->dir, $package );

        write_file(
            path     => $path,
            file     => $filename,
            document => $controller->code,
        );
    }
}

sub _write_psgi {
    my $self = shift;

    write_file(
        path     => $self->dir . "/script",
        file     => 'app.psgi',
        document => template(
            name     => 'psgi',
            template => $self->_psgi_template,
            tidy     => 1,
            data     => {
                app      => $self->app,
                dir      => $self->dir,
                api_base => $self->api_base,
                doc_base => $self->doc_base,
            },
        ),
    );
}

sub _psgi_template {
    state $template;

    return $template //= do {
        my $template_content = unindent(<<'        EOF');
        #!/usr/bin/env perl

        [% rewrite_boundary %]
        use strict;
        use warnings;
        use Plack::Builder;
        use lib 'lib';              # XXX fix me (load Net::OpenAPI::*)
        use lib '../lib';           # XXX fix me (load Net::OpenAPI::*)
        use lib '[% dir %]/lib';    # XXX fix me (load Net::OpenAPI::*)

        use [% app %];

        builder {
            enable "Plack::Middleware::Static", path => qr{^/openapi/.+\.(?:json|yaml)$}, root => '.';
            mount '[% api_base %]' => builder { [% app %]->get_app };
            mount '[% doc_base %]' => builder { [% app %]->doc_index };
        };
        [% rewrite_boundary %]
        EOF

        $template_content;
    };
}

sub _write_app {
    my $self = shift;

    my ( $path, $filename ) = get_path_and_filename( $self->dir, $self->app );

    write_file(
        path     => $path,
        file     => $filename,
        document => $self->code,
    );
}

sub _write_docs {
    my $self = shift;
    my $docs = $self->docs;
    my ( $path, $filename ) = get_path_and_filename( $self->dir, $docs->package );

    write_file(
        path     => $path,
        file     => $filename,
        document => $docs->code,
    );
}

1;
__END__


1;
