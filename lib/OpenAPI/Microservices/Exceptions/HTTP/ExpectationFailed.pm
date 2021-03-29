package OpenAPI::Microservices::Exceptions::HTTP::ExpectationFailed;

# ABSTRACT: Exception class for the HTTP '417 Expectation Failed' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 417.

=cut

sub status_code { 417 }

=head2 C<message>

    my $message = $self->message;

Returns 'Expectation Failed'.

=cut

sub message { 'Expectation Failed' }

1;

