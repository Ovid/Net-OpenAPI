package OpenAPI::Microservices::Exceptions::HTTP::Conflict;

# ABSTRACT: Exception class for the HTTP '409 Conflict' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 409.

=cut

sub status_code { 409 }

=head2 C<message>

    my $message = $self->message;

Returns 'Conflict'.

=cut

sub message { 'Conflict' }

1;
