package Net::OpenAPI::Builder::Endpoint;

# ABSTRACT: Generates the endpoint (method) code.

use Moo;
use Net::OpenAPI::Policy;
use Data::Dumper;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(unindent normalize_string);
use String::Escape qw(quote);
use Scalar::Util qw(looks_like_number blessed);
use Net::OpenAPI::App::Types qw(
  ArrayRef
  Dict
  HashRef
  HTTPMethod
  InstanceOf
  MethodName
  NonEmptyStr
  PackageName
);
our $VERSION = '0.01';

=head1 PARAMETERS

=head2 schema

The L<Net::OpenAPI::App::Validator> for this app.

NOTE: Layering violation, but currently needed to allow extraction of
L</request_params>, L</response_params>, L</description>, and L<summary>.
Ideally, those should be extracted from the schema and passed into C<Endpoint>
instead of having C<Endpoint> depend on C<JSON::Validator::Schema::OpenAPIv3>.

=cut

has validator => (
    is       => 'ro',
    isa      => InstanceOf ['Net::OpenAPI::App::Validator'],
    required => 1,
    handles  => ['schema'],
);

=head2 route

The route for this endpoint, as a C<route> component from
L<JSON::Validator::Schema::OpenAPIv3>

=cut

has route => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

=head2 request_params

The request parameters for this endpoint, as provided by C<parameters_for_request>
from L<JSON::Validator::Schema::OpenAPIv3>.

=cut

=head1 ATTRIBUTES

=head2 ROUTE ATTRIBUTES

All route attributes are extracted from L</route>

=head2 path

=head2 http_method

=head2 request_params

=head2 response_params

=cut

has path => (
    is      => 'lazy',
    builder => sub { shift->route->{path} },
);

# XXX - lowercase? or uppercase?
has http_method => (
    is      => 'lazy',
    isa     => HTTPMethod,
    builder => sub { shift->route->{method} },
);

has request_params => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        my $self = shift;
        return $self->validator->parameters_for_request( [ $self->http_method, $self->path ] ) // [];
    },
);

has response_params => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        my $self = shift;
        return $self->validator->parameters_for_response( [ $self->http_method, $self->path ] ) // [];
    },
);

has description => (
    is      => 'lazy',
    builder => sub {
        my $self   = shift;
        my $schema = $self->schema;
        return $schema->get( [ "paths", $self->path, $self->http_method, "description" ] );
    }
);

has summary => (
    is      => 'lazy',
    builder => sub {
        my $self   = shift;
        my $schema = $self->schema;
        return $schema->get( [ "paths", $self->path, $self->http_method, "summary" ] );
    }
);

=head2 controller_name

The Controller module that should contain this endpoint.

POLICY: The Controller is determined by the top-level path component in the C<path>

=head2 action_name

Generated/mangled action name for this endpoint

=head2 action_args

Args for this endpoint action

=cut

has _method_info => (
    is  => 'lazy',
    isa => Dict [
        controller_name => PackageName,
        action_name     => MethodName,
        action_args     => ArrayRef,
    ],
    builder => sub {
        my $self = shift;

        # grab everything except first path part
        my ( $controller, @path ) = grep {/\S/} split m{/} => $self->path;
        $controller = ucfirst normalize_string($controller);

        my $action = lc $self->http_method;

        my @args;
        foreach my $element (@path) {
            if ( $element =~ /^{(?<arg>\w+)}$/ ) {
                push @args => $+{arg};
                $action .= '___';
            }
            elsif ( $action =~ /_$/ ) {
                $action .= $element;
            }
            else {
                $action .= "_$element";
            }
        }
        if (@args) {
            $action = "with_args_$action";
        }
        $action =~ s/_+$//;
        $action =~ s/-/_/g;

        return {
            controller_name => $controller,
            action_name     => $action,
            action_args     => \@args,
        };
    },
);

sub controller_name { shift->_method_info->{controller_name} }

sub action_name { shift->_method_info->{action_name} }

sub action_args { shift->_method_info->{action_args} }

=head1 OUTPUT ATTRIBUTES

=head2 code

Code for generated method stub

=cut

has code => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    builder => sub {
        my $self        = shift;
        my $description = $self->description || $self->summary || 'No description found';
        return template(
            name     => 'method',
            template => $self->_endpoint_template,
            data     => {
                request_params  => $self->_format_params( $self->request_params ),
                response_params => $self->_format_params( $self->response_params ),
                path            => $self->path,
                http_method     => $self->http_method,
                description     => $description,
                response_class  => 'Net::OpenAPI::App::Response',                     # XXX Fixme
            }
        );
    },
);

sub _format_params {

    # this ugly bit of code is designed to ensure that each component of a
    # parameter shows up on a single line in the docs. It makes them much
    # easier to read than the current sprawl.
    my ( $self, $params ) = @_;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Terse    = 1;
    my @params = @$params;
    my $docs   = '';
    foreach my $param (@params) {
        $docs .= "    {\n";
        my $max = $self->_max_length( keys %$param );
        foreach my $field ( sort keys %$param ) {
            my $value = $param->{$field};
            if ( blessed $value ) {
                $value = 0 + $value;    # JSON::PP::Boolean and friends
            }
            elsif ( ref $value ) {
                $value = Dumper($value);
            }
            elsif ( !looks_like_number($value) ) {
                $value = quote( $value // 0 );
            }
            $docs .= sprintf "        %-${max}s => $value,\n" => $field;
        }
        $docs .= "    }\n";
    }
    return $docs;
}

sub _max_length {
    my ( $self, @strings ) = @_;
    my $max = 0;
    for (@strings) {
        $max = length($_) if length($_) > $max;
    }
    return $max;
}

sub _endpoint_template {
    state $template;

    return $template //= do {
        my $template_content = unindent(<<'        EOF');
        =head2 C<[% http_method %] [% path %]>

        [% description %]

        =head2 Request Parameters

        [% request_params %]

        =head2 Response Parameters

        [% response_params %]

        =cut

        endpoint '[% http_method %] [% path %]' => sub {
            my ($request, $params) = @_;
            return [% response_class %]->new(
               status_code => HTTPNotImplemented,
               body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => '[% http_method %] [% path %]' },
            );
        };
        EOF

        $template_content;
    };
}

1;
