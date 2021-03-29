package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::MovedPermanently;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {301}
sub message     {'Moved Permanently'}

1;

