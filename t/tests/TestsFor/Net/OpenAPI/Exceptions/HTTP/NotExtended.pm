package TestsFor::Net::OpenAPI::Exceptions::HTTP::NotExtended;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {510}
sub message     {'Not Extended'}

__PACKAGE__->meta->make_immutable;

