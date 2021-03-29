package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::InternalServerError;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {500}
sub message     {'Internal Server Error'}

1;

