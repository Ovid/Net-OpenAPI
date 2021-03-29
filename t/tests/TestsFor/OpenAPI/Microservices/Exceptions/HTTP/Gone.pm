package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Gone;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {410}
sub message     {'Gone'}

1;

