package Net::OpenAPI::Exceptions::HTTP::NetworkAuthenticationRequired;

# ABSTRACT: Exception class for the HTTP '511 Network Authentication Required' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 511.

=cut

sub status_code { 511 }

=head2 C<message>

    my $message = $self->message;

Returns 'Network Authentication Required'.

=cut

sub message { 'Network Authentication Required' }

1;

