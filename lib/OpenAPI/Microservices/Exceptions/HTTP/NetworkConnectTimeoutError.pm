package OpenAPI::Microservices::Exceptions::HTTP::NetworkConnectTimeoutError;

# ABSTRACT: Exception class for the HTTP '599 Network Connect Timeout Error' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 599.

=cut

sub status_code { 599 }

=head2 C<message>

    my $message = $self->message;

Returns 'Network Connect Timeout Error'.

=cut

sub message { 'Network Connect Timeout Error' }

1;

