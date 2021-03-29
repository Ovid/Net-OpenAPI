package OpenAPI::Microservices::Exceptions::HTTP::InternalServerError;

# ABSTRACT: Exception class for the HTTP '500 Internal Server Error' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 500.

=cut

sub status_code { 500 }

=head2 C<message>

    my $message = $self->message;

Returns 'Internal Server Error'.

=cut

sub message { 'Internal Server Error' }

1;

