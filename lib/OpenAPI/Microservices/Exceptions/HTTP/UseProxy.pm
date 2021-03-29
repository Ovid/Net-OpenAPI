package OpenAPI::Microservices::Exceptions::HTTP::UseProxy;

# ABSTRACT: Exception class for the HTTP '305 Use Proxy' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 305.

=cut

sub status_code { 305 }

=head2 C<message>

    my $message = $self->message;

Returns 'Use Proxy'.

=cut

sub message { 'Use Proxy' }

1;

