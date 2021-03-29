package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Locked;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {423}
sub message     {'Locked'}

1;

