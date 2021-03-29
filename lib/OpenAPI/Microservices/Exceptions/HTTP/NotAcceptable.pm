package OpenAPI::Microservices::Exceptions::HTTP::NotAcceptable;

# ABSTRACT: Exception class for the HTTP '406 Not Acceptable' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 406.

=cut

sub status_code { 406 }

=head2 C<message>

    my $message = $self->message;

Returns 'Not Acceptable'.

=cut

sub message { 'Not Acceptable' }

1;

