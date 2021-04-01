package TestsFor::Net::OpenAPI::Exceptions::HTTP::NetworkAuthenticationRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {511}
sub message     {'Network Authentication Required'}

1;

