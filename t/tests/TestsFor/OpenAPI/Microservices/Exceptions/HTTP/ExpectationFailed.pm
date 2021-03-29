package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::ExpectationFailed;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {417}
sub message     {'Expectation Failed'}

1;

