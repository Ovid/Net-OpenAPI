package OpenAPI::Microservices::Exceptions::HTTP::Forbidden;

# ABSTRACT: Exception class for the HTTP '403 Forbidden' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 403.

=cut

sub status_code { 403 }

=head2 C<message>

    my $message = $self->message;

Returns 'Forbidden'.

=cut

sub message { 'Forbidden' }

1;

