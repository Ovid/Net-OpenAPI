package OpenAPI::Microservices::Exceptions::HTTP::SeeOther;

# ABSTRACT: Exception class for the HTTP '303 See Other' error

use Moo;
with 'OpenAPI::Microservices::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'OpenAPI::Microservices::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 303.

=cut

sub status_code { 303 }

=head2 C<message>

    my $message = $self->message;

Returns 'See Other'.

=cut

sub message { 'See Other' }

1;
