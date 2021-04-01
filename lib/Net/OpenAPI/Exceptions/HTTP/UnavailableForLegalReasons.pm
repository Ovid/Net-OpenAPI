package Net::OpenAPI::Exceptions::HTTP::UnavailableForLegalReasons;

# ABSTRACT: Exception class for the HTTP '451 Unavailable For Legal Reasons' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 451.

=cut

sub status_code { 451 }

=head2 C<message>

    my $message = $self->message;

Returns 'Unavailable For Legal Reasons'.

=cut

sub message { 'Unavailable For Legal Reasons' }

1;

