package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::PreconditionRequired;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {428}
sub message     {'Precondition Required'}

1;

