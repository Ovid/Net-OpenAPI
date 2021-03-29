package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NetworkConnectTimeoutError;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {599}
sub message     {'Network Connect Timeout Error'}

1;

