package OpenAPI::Microservices::Exceptions::HTTP::BadGateway;

# ABSTRACT: Exception class for the HTTP '502 Bad Gateway' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 502.

=cut

sub status_code { 502 }

=head2 C<message>

    my $message = $self->message;

Returns 'Bad Gateway'.

=cut

sub message { 'Bad Gateway' }

1;

