package OpenAPI::Microservices::Exceptions::HTTP::NotModified;

# ABSTRACT: Exception class for the HTTP '304 Not Modified' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 304.

=cut

sub status_code { 304 }

=head2 C<message>

    my $message = $self->message;

Returns 'Not Modified'.

=cut

sub message { 'Not Modified' }

1;

