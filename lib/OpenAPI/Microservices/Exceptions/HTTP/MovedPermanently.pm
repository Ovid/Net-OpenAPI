package OpenAPI::Microservices::Exceptions::HTTP::MovedPermanently;

# ABSTRACT: Exception class for the HTTP '301 Moved Permanently' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 301.

=cut

sub status_code { 301 }

=head2 C<message>

    my $message = $self->message;

Returns 'Moved Permanently'.

=cut

sub message { 'Moved Permanently' }

1;

