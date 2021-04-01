package Net::OpenAPI::Exceptions::HTTP::GatewayTimeout;

# ABSTRACT: Exception class for the HTTP '504 Gateway Timeout' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 504.

=cut

sub status_code { 504 }

=head2 C<message>

    my $message = $self->message;

Returns 'Gateway Timeout'.

=cut

sub message { 'Gateway Timeout' }

1;

