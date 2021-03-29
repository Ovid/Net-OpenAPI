package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::PayloadTooLarge;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {413}
sub message     {'Payload Too Large'}

1;

