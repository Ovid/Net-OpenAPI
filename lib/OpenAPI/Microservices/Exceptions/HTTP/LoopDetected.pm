package OpenAPI::Microservices::Exceptions::HTTP::LoopDetected;

# ABSTRACT: Exception class for the HTTP '508 Loop Detected' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 508.

=cut

sub status_code { 508 }

=head2 C<message>

    my $message = $self->message;

Returns 'Loop Detected'.

=cut

sub message { 'Loop Detected' }

1;

