package Net::OpenAPI::App::Validator;

# ABSTRACT: Net::OpenAPI validation class

use Moo;
use Storable 'dclone';
use Scalar::Util 'blessed';
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  HashRef
  InstanceOf
  NonEmptyStr
);

use JSON::Validator::Schema::OpenAPIv3;
use namespace::autoclean;

has raw_schema => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

has _validator => (
    is      => 'lazy',
    isa     => InstanceOf ['JSON::Validator::Schema::OpenAPIv3'],
    builder => sub {
        my $self = shift;
        return JSON::Validator::Schema::OpenAPIv3->new( $self->raw_schema );
    },
    handles => [ 'schema', 'errors' ],
);

has _schema_as_perl => (
    is      => 'lazy',
    isa     => HashRef,
    builder => sub {
        my $self = shift;
        return $self->_resolve_component;
    }
);

=head2 C<get_component(@path)>

    my $value = $validator->get_component(qw/components schemas Pet/);

Returns the value in the schema corresponding to C<@path>. This value is a
Perl data structure with booleans properly handled and refs already inflated.

Calling C<get_component> without arguments will return the entire schema
object.

=cut

sub get_component {
    my ( $self, @path ) = @_;

    # for now, assume hash keys
    my $schema = $self->_schema_as_perl;
    foreach my $key (@path) {
        $schema = $schema->{$key} or return;
    }
    return dclone($schema);
}

=head2 C<parameters_for_request( $method, $path )>

    my $params = $validator->parameters_for_request( 'GET', '/path/to/{something}' );

Like L<JSON::Validator::Schema::OpenAPIv3>'s C<parameters_for_request> method,
but we fully expand C<$ref>s and booleans.

=cut

sub parameters_for_request {
    my ( $self, $method, $path ) = @_;
    my $params   = $self->_validator->parameters_for_request( $method, $path ) or return;
    my $resolver = $self->_resolution_method($params);
    return $self->$resolver($params);
}

=head2 C<parameters_for_response( $method, $path )>

    my $params = $validator->parameters_for_response( 'GET', '/path/to/{something}' );

Like L<JSON::Validator::Schema::OpenAPIv3>'s C<parameters_for_response> method,
but we fully expand C<$ref>s and booleans.

=cut

sub parameters_for_response {
    my ( $self, $method, $path ) = @_;
    my $params   = $self->_validator->parameters_for_response( $method, $path ) or return;
    my $resolver = $self->_resolution_method($params);
    return $self->$resolver($params);
}

sub _resolve_component {
    my ( $self, @path ) = @_;
    my $component = $self->schema->get( [@path] );
    my $resolver  = $self->_resolution_method($component);
    return $self->$resolver($component);
}

sub _resolve_href {
    my ( $self, $href ) = @_;
    KEY: foreach my $key ( keys %$href ) {
        my $value    = $href->{$key};
        my $resolver = $self->_resolution_method($value) or next KEY;
        $href->{$key} = $self->$resolver($value);
    }
    return $href;
}

sub _resolve_json_ref {

    # See also: https://tools.ietf.org/html/draft-pbryan-zyp-json-ref-03
    my ( $self, $ref ) = @_;

    # XXX Jan Henning has mentioned in email to me that he's thinking about
    # redoing how $ref is handled. Further, it's documented as internal.
    my ($path) = values %$ref;
    my @path = split m{/} => $path;
    shift @path;    # remove leading '#'
    return $self->_resolve_component(@path);
}

sub _resolve_aref {
    my ( $self, $aref ) = @_;
    ELEMENT: for my $i ( 0 .. $#$aref ) {
        my $value    = $aref->[$i];
        my $resolver = $self->_resolution_method($value) or next ELEMENT;
        $aref->[$i] = $self->$resolver($value);
    }
    return $aref;
}

sub _resolve_other {
    my ( $self, $value ) = @_;
    blessed $value or croak("PANIC: trying to resolve unknown value: ($value)");
    return $value->isa('JSON::PP::Boolean')
      ? 0 + $value
      : croak("Do not know how to resolve ($value)");
}

sub _resolution_method {
    my ( $self, $value ) = @_;
    return unless ref $value;
    if ( 'HASH' eq ref $value && 1 == keys %$value ) {
        my ($key) = keys %$value;
        if ( '$ref' eq $key ) {
            return '_resolve_json_ref';
        }
    }
    return
        'HASH' eq ref $value  ? '_resolve_href'
      : 'ARRAY' eq ref $value ? '_resolve_aref'
      :                         '_resolve_other';
}

1;
