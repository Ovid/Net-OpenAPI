package Net::OpenAPI::Exceptions::HTTP::MisdirectedRequest;

# ABSTRACT: Exception class for the HTTP '421 Misdirected Request' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 421.

=cut

sub status_code { 421 }

=head2 C<message>

    my $message = $self->message;

Returns 'Misdirected Request'.

=cut

sub message { 'Misdirected Request' }

1;

