package OpenAPI::Microservices::Exceptions::HTTP::TemporaryRedirect;

# ABSTRACT: Exception class for the HTTP '307 Temporary Redirect' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 307.

=cut

sub status_code { 307 }

=head2 C<message>

    my $message = $self->message;

Returns 'Temporary Redirect'.

=cut

sub message { 'Temporary Redirect' }

1;

