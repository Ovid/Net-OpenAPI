package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::InsufficientStorage;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {507}
sub message     {'Insufficient Storage'}

1;

