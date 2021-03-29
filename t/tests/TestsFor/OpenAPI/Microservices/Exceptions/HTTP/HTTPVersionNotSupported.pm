package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::HTTPVersionNotSupported;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {505}
sub message     {'HTTP Version Not Supported'}

1;

