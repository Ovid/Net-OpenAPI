package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NotFound;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {404}
sub message     {'Not Found'}

1;

