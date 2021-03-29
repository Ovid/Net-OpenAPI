package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::NotAcceptable;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {406}
sub message     {'Not Acceptable'}

1;

