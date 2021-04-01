package Net::OpenAPI::Exceptions::HTTP::Locked;

# ABSTRACT: Exception class for the HTTP '423 Locked' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 423.

=cut

sub status_code { 423 }

=head2 C<message>

    my $message = $self->message;

Returns 'Locked'.

=cut

sub message { 'Locked' }

1;

