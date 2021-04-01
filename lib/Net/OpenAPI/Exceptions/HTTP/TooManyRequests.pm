package Net::OpenAPI::Exceptions::HTTP::TooManyRequests;

# ABSTRACT: Exception class for the HTTP '429 Too Many Requests' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 429.

=cut

sub status_code { 429 }

=head2 C<message>

    my $message = $self->message;

Returns 'Too Many Requests'.

=cut

sub message { 'Too Many Requests' }

1;

