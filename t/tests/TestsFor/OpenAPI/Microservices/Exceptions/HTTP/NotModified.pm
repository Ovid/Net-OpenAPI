package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NotModified;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {304}
sub message     {'Not Modified'}

1;

