package Net::OpenAPI::Exceptions::HTTP::Unauthorized;

# ABSTRACT: Exception class for the HTTP '401 Unauthorized' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 401.

=cut

sub status_code { 401 }

=head2 C<message>

    my $message = $self->message;

Returns 'Unauthorized'.

=cut

sub message { 'Unauthorized' }

1;

