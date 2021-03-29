package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::BadRequest;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {400}
sub message     {'Bad Request'}

1;

