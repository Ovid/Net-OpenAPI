package Net::OpenAPI::Exceptions::HTTP::UnsupportedMediaType;

# ABSTRACT: Exception class for the HTTP '415 Unsupported Media Type' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 415.

=cut

sub status_code { 415 }

=head2 C<message>

    my $message = $self->message;

Returns 'Unsupported Media Type'.

=cut

sub message { 'Unsupported Media Type' }

1;

