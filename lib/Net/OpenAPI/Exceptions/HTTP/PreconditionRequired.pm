package Net::OpenAPI::Exceptions::HTTP::PreconditionRequired;

# ABSTRACT: Exception class for the HTTP '428 Precondition Required' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 428.

=cut

sub status_code { 428 }

=head2 C<message>

    my $message = $self->message;

Returns 'Precondition Required'.

=cut

sub message { 'Precondition Required' }

1;

