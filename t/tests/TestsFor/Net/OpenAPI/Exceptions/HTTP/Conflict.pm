package TestsFor::Net::OpenAPI::Exceptions::HTTP::Conflict;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {409}
sub message     {'Conflict'}

__PACKAGE__->meta->make_immutable;

