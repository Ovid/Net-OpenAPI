package OpenAPI::Microservices::Exceptions::HTTP::BadRequest;

# ABSTRACT: Exception class for the HTTP '400 Bad Request' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 400.

=cut

sub status_code { 400 }

=head2 C<message>

    my $message = $self->message;

Returns 'Bad Request'.

=cut

sub message { 'Bad Request' }

1;

