package OpenAPI::Microservices::Exceptions::HTTP::RequestURITooLong;

# ABSTRACT: Exception class for the HTTP '414 Request-URI Too Long' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 414.

=cut

sub status_code { 414 }

=head2 C<message>

    my $message = $self->message;

Returns 'Request-URI Too Long'.

=cut

sub message { 'Request-URI Too Long' }

1;

