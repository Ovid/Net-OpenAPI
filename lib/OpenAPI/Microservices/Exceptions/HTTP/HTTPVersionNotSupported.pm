package OpenAPI::Microservices::Exceptions::HTTP::HTTPVersionNotSupported;

# ABSTRACT: Exception class for the HTTP '505 HTTP Version Not Supported' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 505.

=cut

sub status_code { 505 }

=head2 C<message>

    my $message = $self->message;

Returns 'HTTP Version Not Supported'.

=cut

sub message { 'HTTP Version Not Supported' }

1;

