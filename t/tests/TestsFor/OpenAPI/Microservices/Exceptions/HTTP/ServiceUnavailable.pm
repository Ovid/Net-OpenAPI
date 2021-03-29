package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::ServiceUnavailable;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {503}
sub message     {'Service Unavailable'}

1;

