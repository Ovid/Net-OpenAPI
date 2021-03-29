package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::RequestHeaderFieldsTooLarge;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {431}
sub message     {'Request Header Fields Too Large'}

1;

