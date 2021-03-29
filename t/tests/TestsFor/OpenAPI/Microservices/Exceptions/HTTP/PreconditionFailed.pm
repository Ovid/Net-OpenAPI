package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::PreconditionFailed;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {412}
sub message     {'Precondition Failed'}

1;

