package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::UnprocessableEntity;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {422}
sub message     {'Unprocessable Entity'}

1;

