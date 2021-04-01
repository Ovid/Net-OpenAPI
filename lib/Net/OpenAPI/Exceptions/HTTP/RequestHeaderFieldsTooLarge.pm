package Net::OpenAPI::Exceptions::HTTP::RequestHeaderFieldsTooLarge;

# ABSTRACT: Exception class for the HTTP '431 Request Header Fields Too Large' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 431.

=cut

sub status_code { 431 }

=head2 C<message>

    my $message = $self->message;

Returns 'Request Header Fields Too Large'.

=cut

sub message { 'Request Header Fields Too Large' }

1;

