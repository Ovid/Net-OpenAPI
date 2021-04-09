package Net::OpenAPI::Builder::Controller;

use Moo;
use Net::OpenAPI::Policy;
use Data::Dumper;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(unindent tidy_code);
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

=head2 endpoints

The endpoints for this Controller, as ArrayRef of L<Net::OpenAPI::Builder::Endpoint>

=cut

has endpoints => (
    is       => 'ro',
    isa      => ArrayRef [ InstanceOf ['Net::OpenAPI::Builder::Endpoint'] ],
    required => 1,
);

=head1 ATTRIBUTES

=head2 errors

Errors: duplicate endpoints or duplicate generated methods

=cut

has errors => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        my $self = shift;

        my ( @errors, %paths_seen, %actions_seen );
        for my $endpoint ( @{ $self->endpoints } ) {
            my $path        = $endpoint->path;
            my $http_method = lc $endpoint->http_method;
            my $action      = $endpoint->action_name;

            if ( $paths_seen{$path}{$http_method}++ ) {
                push @errors, "Duplicate endpoint: path: $path, method: $http_method";
            }

            # XXX - should never happen
            elsif ( $actions_seen{$action}++ ) {
                push @errors, "Internal error: duplicate generated action: $action";
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
        my @endpoints = sort { length( $a->path ) <=> length( $b->path ) || $a->action_name cmp $b->action_name } @{ $self->endpoints };

        return tidy_code(
            template(
                name     => 'controller',
                template => $self->_controller_template,
                data     => {
                    package   => $self->package,
                    template  => $self->_controller_template,
                    endpoints => \@endpoints,
                },
                tidy => 1,
            )
        );
    }
);

sub _controller_template {
    state $template;

    return $template //= do {
        my $template_content = unindent(<<'        EOF');
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

        =cut

        [% rewrite_boundary %]
        sub routes {
            return [
                [% FOREACH endpoint IN endpoints %]{ path => '[% endpoint.path %]', http_method => '[% endpoint.http_method %]', action => '[% endpoint.action_name %]' },[% END %]
            ];
        }
        [% rewrite_boundary %]

        =head1 ROUTES

        [% FOREACH endpoint IN endpoints %]
        [% endpoint.code %]
        [% END %]

        1;
        EOF

        $template_content;
    };
}

1;
