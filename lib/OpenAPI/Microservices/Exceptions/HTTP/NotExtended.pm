package OpenAPI::Microservices::Exceptions::HTTP::NotExtended;

# ABSTRACT: Exception class for the HTTP '510 Not Extended' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 510.

=cut

sub status_code { 510 }

=head2 C<message>

    my $message = $self->message;

Returns 'Not Extended'.

=cut

sub message { 'Not Extended' }

1;

