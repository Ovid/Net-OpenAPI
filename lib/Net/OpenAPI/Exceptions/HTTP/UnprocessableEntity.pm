package Net::OpenAPI::Exceptions::HTTP::UnprocessableEntity;

# ABSTRACT: Exception class for the HTTP '422 Unprocessable Entity' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 422.

=cut

sub status_code { 422 }

=head2 C<message>

    my $message = $self->message;

Returns 'Unprocessable Entity'.

=cut

sub message { 'Unprocessable Entity' }

1;

