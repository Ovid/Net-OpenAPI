package Net::OpenAPI::Exceptions::HTTP::ClientClosedRequest;

# ABSTRACT: Exception class for the HTTP '499 Client Closed Request' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 499.

=cut

sub status_code { 499 }

=head2 C<message>

    my $message = $self->message;

Returns 'Client Closed Request'.

=cut

sub message { 'Client Closed Request' }

1;
