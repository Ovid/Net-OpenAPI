package Net::OpenAPI::Exceptions::HTTP::PayloadTooLarge;

# ABSTRACT: Exception class for the HTTP '413 Payload Too Large' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 413.

=cut

sub status_code { 413 }

=head2 C<message>

    my $message = $self->message;

Returns 'Payload Too Large'.

=cut

sub message { 'Payload Too Large' }

1;

