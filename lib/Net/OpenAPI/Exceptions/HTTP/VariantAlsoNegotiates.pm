package Net::OpenAPI::Exceptions::HTTP::VariantAlsoNegotiates;

# ABSTRACT: Exception class for the HTTP '506 Variant Also Negotiates' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 506.

=cut

sub status_code { 506 }

=head2 C<message>

    my $message = $self->message;

Returns 'Variant Also Negotiates'.

=cut

sub message { 'Variant Also Negotiates' }

1;

