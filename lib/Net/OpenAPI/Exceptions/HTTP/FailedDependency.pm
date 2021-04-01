package Net::OpenAPI::Exceptions::HTTP::FailedDependency;

# ABSTRACT: Exception class for the HTTP '424 Failed Dependency' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my $code = $self->status_code;

Returns 424.

=cut

sub status_code { 424 }

=head2 C<message>

    my $message = $self->message;

Returns 'Failed Dependency'.

=cut

sub message { 'Failed Dependency' }

1;

