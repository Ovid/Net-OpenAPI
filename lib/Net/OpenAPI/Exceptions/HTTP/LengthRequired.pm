package Net::OpenAPI::Exceptions::HTTP::LengthRequired;

# ABSTRACT: Exception class for the HTTP '411 Length Required' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 411.

=cut

sub status_code { 411 }

=head2 C<message>

    my $message = $self->message;

Returns 'Length Required'.

=cut

sub message { 'Length Required' }

1;

