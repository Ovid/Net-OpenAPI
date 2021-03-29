package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NotExtended;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {510}
sub message     {'Not Extended'}

1;

