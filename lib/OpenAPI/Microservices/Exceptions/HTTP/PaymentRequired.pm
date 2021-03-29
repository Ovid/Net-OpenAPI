package OpenAPI::Microservices::Exceptions::HTTP::PaymentRequired;

# ABSTRACT: Exception class for the HTTP '402 Payment Required' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 402.

=cut

sub status_code { 402 }

=head2 C<message>

    my $message = $self->message;

Returns 'Payment Required'.

=cut

sub message { 'Payment Required' }

1;

