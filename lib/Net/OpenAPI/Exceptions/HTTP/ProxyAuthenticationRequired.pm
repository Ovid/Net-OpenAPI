package Net::OpenAPI::Exceptions::HTTP::ProxyAuthenticationRequired;

# ABSTRACT: Exception class for the HTTP '407 Proxy Authentication Required' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 407.

=cut

sub status_code { 407 }

=head2 C<message>

    my $message = $self->message;

Returns 'Proxy Authentication Required'.

=cut

sub message { 'Proxy Authentication Required' }

1;

