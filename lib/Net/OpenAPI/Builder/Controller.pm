package Net::OpenAPI::Builder::Controller;

use Moo;
use Net::OpenAPI::Policy;
use Data::Dumper;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(tidy_code);
use String::Escape qw(quote);
use Scalar::Util qw(looks_like_number blessed);
use Net::OpenAPI::App::Types qw(
  ArrayRef
  Dict
  HTTPMethod
  HashRef
  InstanceOf
  MethodName
  NonEmptySimpleStr
  NonEmptyStr
  PackageName
  Str
);

=head1 PARAMETERS

=head2 base

The base package path for this Controller

=cut

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

=head2 name

The package name of this Controller, within the C<Controller> namespace

=cut

has name => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

=head2 routes

The routes for this Controller, as ArrayRef of L<Net::OpenAPI::Builder::Endpoint>

=cut

has routes => (
    is       => 'ro',
    isa      => ArrayRef [ InstanceOf ['Net::OpenAPI::Builder::Endpoint'] ],
    required => 1,
);

=head1 ATTRIBUTES

=head2 errors

Errors: duplicate routes or duplicate generated methods

=cut

has errors => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        my $self = shift;

        my ( @errors, %routes_seen, %methods_seen );
        for my $route ( @{ $self->routes } ) {
            my $path        = $route->path;
            my $http_method = lc $route->http_method;
            my $method      = $route->method_name;

            if ( $routes_seen{$path}{$http_method}++ ) {
                push @errors, "Duplicate route: path: $path, method: $http_method";
            }

            # XXX - should never happen
            elsif ( $methods_seen{$method}++ ) {
                push @errors, "Internal error: duplicate generated method: $method";
            }
        }

        return \@errors;
    },
);

=head2 package

Full package name within Controller namespace

=cut

has package => (
    is      => 'lazy',
    isa     => PackageName,
    builder => sub {
        my $self = shift;
        return join '::' => $self->base, 'Controller', $self->name;
    },
);

=head1 OUTPUT ATTRIBUTES

=head2 code

All generated code for this Controller

=cut

has code => (
    is      => 'lazy',
    isa     => Str,
    builder => sub {
        my $self = shift;

        # the sort keeps the auto-generated code deterministic. We put short paths
        # first just because it's easier to read, but we break ties by sorting on
        # the guaranteed unique generated method names
        my @routes = map { $_->code } sort { length( $a->path ) <=> length( $b->path ) || $a->method_name cmp $b->method_name } @{ $self->routes };

        template(
            name     => 'controller',
            template => $self->_controller_template,
            data     => {
                package  => $self->package,
                template => $self->_controller_template,
                routes   => \@routes,
            },
            tidy => 1,
        );
    }
);

sub _controller_template {
    state $template;

    return $template //= do {
        ( my $template_content = <<'        EOF' ) =~ s/\n        /\n/gm;
        package [% package %];

        use strict;
        use warnings;
        use Net::OpenAPI::App::Endpoint;
        use Net::OpenAPI::App::Response;
        use Net::OpenAPI::App::StatusCodes ':all';

        =head1 NAME

        [% package %] - Net::OpenAPI controller

        =head1 DESCRIPTION

        This controller merely declares the OpenAPI routes. This is used by the
        L<Net::OpenAPI::App::Router> at compile time to determine which
        model and method incoming requests are directed to.

        L<Net::OpenAPI::App::Router> at compile time to determine which
        model and method incoming requests are directed to.

        [% REWRITE_BOUNDARY %]
        sub routes {
            return [
                [% FOREACH route IN routes %]
                { path => '[% route.path %]', http_method => '[% route.http_method %], method => '[% route.method %]' },
                [% END %]
            ]
        }
        [% REWRITE_BOUNDARY %]

        =head1 ROUTES

        [% FOREACH route IN routes %]
        [% route.code %]
        [% END %]

        1;
        EOF

        $template_content;
    };
}

1;
