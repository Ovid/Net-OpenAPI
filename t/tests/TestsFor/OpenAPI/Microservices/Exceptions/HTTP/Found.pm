package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Found;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {302}
sub message     {'Found'}

1;

