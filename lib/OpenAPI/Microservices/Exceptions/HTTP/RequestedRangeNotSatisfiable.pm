package OpenAPI::Microservices::Exceptions::HTTP::RequestedRangeNotSatisfiable;

# ABSTRACT: Exception class for the HTTP '416 Requested Range Not Satisfiable' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 416.

=cut

sub status_code { 416 }

=head2 C<message>

    my $message = $self->message;

Returns 'Requested Range Not Satisfiable'.

=cut

sub message { 'Requested Range Not Satisfiable' }

1;

