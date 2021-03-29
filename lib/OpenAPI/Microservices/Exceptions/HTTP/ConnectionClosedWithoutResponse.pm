package OpenAPI::Microservices::Exceptions::HTTP::ConnectionClosedWithoutResponse;

# ABSTRACT: Exception class for the HTTP '444 Connection Closed Without Response' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 444.

=cut

sub status_code { 444 }

=head2 C<message>

    my $message = $self->message;

Returns 'Connection Closed Without Response'.

=cut

sub message { 'Connection Closed Without Response' }

1;

