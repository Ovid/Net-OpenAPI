package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Unauthorized;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {401}
sub message     {'Unauthorized'}

1;

