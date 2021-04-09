package Net::OpenAPI::App::Response;

# ABSTRACT: Net::OpenAPI responses

use Moo;
use Mojo::JSON 'encode_json';
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  HashRef
  HTTPStatusCode
);
use namespace::autoclean;

has status_code => (
    is       => 'ro',
    isa      => HTTPStatusCode,
    required => 1,
);

has body => (
    is       => 'ro',
    isa      => HashRef,
    required => 0,
);

sub to_json {
    my $self = shift;
    my $body = $self->body or return '';
    return encode_json($body);
}

# Punting on XML for now:
# https://swagger.io/docs/specification/data-models/representing-xml/

1;

__END__

=head1 METHODS

=head2 C<status_code>

    my $code = $response->status_code;

Returns the numeric HTTP status code for this response.

=head2 C<body>


    my $body = $response->body;

Optional. If present, it's a hashref with the response body.
