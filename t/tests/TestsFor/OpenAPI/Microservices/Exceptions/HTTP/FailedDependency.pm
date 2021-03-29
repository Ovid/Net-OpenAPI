package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::FailedDependency;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {424}
sub message     {'Failed Dependency'}

1;

