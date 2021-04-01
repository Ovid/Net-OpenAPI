package Net::OpenAPI::Exceptions::HTTP::ServiceUnavailable;

# ABSTRACT: Exception class for the HTTP '503 Service Unavailable' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 503.

=cut

sub status_code { 503 }

=head2 C<message>

    my $message = $self->message;

Returns 'Service Unavailable'.

=cut

sub message { 'Service Unavailable' }

1;
