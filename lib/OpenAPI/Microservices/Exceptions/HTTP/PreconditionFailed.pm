package OpenAPI::Microservices::Exceptions::HTTP::PreconditionFailed;

# ABSTRACT: Exception class for the HTTP '412 Precondition Failed' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 412.

=cut

sub status_code { 412 }

=head2 C<message>

    my $message = $self->message;

Returns 'Precondition Failed'.

=cut

sub message { 'Precondition Failed' }

1;

