package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::SeeOther;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {303}
sub message     {'See Other'}

1;

