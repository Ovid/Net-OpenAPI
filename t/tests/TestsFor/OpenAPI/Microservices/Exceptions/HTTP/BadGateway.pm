package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::BadGateway;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {502}
sub message     {'Bad Gateway'}

1;

