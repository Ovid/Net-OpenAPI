package OpenAPI::Microservices::Exceptions::HTTP::PermanentRedirect;

# ABSTRACT: Exception class for the HTTP '308 Permanent Redirect' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 308.

=cut

sub status_code { 308 }

=head2 C<message>

    my $message = $self->message;

Returns 'Permanent Redirect'.

=cut

sub message { 'Permanent Redirect' }

1;

