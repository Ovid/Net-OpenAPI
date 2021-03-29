package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::RequestURITooLong;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {414}
sub message     {'Request-URI Too Long'}

1;

