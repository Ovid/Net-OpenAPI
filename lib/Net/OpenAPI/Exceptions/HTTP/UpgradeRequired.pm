package Net::OpenAPI::Exceptions::HTTP::UpgradeRequired;

# ABSTRACT: Exception class for the HTTP '426 Upgrade Required' error

use Moo;
extends 'Net::OpenAPI::Exceptions::Base';
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 426.

=cut

sub status_code { 426 }

=head2 C<message>

    my $message = $self->message;

Returns 'Upgrade Required'.

=cut

sub message { 'Upgrade Required' }

1;

