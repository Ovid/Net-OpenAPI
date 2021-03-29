package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::RequestTimeout;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {408}
sub message     {'Request Timeout'}

1;

