package OpenAPI::Microservices::Exceptions::HTTP::Gone;

# ABSTRACT: Exception class for the HTTP '410 Gone' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 410.

=cut

sub status_code { 410 }

=head2 C<message>

    my $message = $self->message;

Returns 'Gone'.

=cut

sub message { 'Gone' }

1;

