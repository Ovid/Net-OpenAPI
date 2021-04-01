package Net::OpenAPI::Exceptions::HTTP::NotFound;

# ABSTRACT: Exception class for the HTTP '404 Not Found' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 404.

=cut

sub status_code { 404 }

=head2 C<message>

    my $message = $self->message;

Returns 'Not Found'.

=cut

sub message { 'Not Found' }

1;

