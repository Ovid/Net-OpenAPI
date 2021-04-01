package Net::OpenAPI::Exceptions::HTTP::NotImplemented;

# ABSTRACT: Exception class for the HTTP '501 Not Implemented' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 501.

=cut

sub status_code { 501 }

=head2 C<message>

    my $message = $self->message;

Returns 'Not Implemented'.

=cut

sub message { 'Not Implemented' }

1;

