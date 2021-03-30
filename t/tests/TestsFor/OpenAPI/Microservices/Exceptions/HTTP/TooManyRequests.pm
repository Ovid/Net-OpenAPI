package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::TooManyRequests;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {429}
sub message     {'Too Many Requests'}

1;
