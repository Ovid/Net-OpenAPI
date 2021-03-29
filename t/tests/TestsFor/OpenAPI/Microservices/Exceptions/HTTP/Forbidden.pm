package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Forbidden;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {403}
sub message     {'Forbidden'}

1;

