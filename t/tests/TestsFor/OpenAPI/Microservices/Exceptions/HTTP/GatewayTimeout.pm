package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::GatewayTimeout;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {504}
sub message     {'Gateway Timeout'}

1;

