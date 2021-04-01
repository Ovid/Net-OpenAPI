package Net::OpenAPI::Exceptions::HTTP::MethodNotAllowed;

# ABSTRACT: Exception class for the HTTP '405 Method Not Allowed' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 405.

=cut

sub status_code { 405 }

=head2 C<message>

    my $message = $self->message;

Returns 'Method Not Allowed'.

=cut

sub message { 'Method Not Allowed' }

1;

