package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NotImplemented;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {501}
sub message     {'Not Implemented'}

1;

