package Net::OpenAPI::Exceptions::HTTP::MultipleChoices;

# ABSTRACT: Exception class for the HTTP '300 Multiple Choices' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 300.

=cut

sub status_code { 300 }

=head2 C<message>

    my $message = $self->message;

Returns 'Multiple Choices'.

=cut

sub message { 'Multiple Choices' }

1;

