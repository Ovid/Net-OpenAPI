package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::UseProxy;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {305}
sub message     {'Use Proxy'}

1;

