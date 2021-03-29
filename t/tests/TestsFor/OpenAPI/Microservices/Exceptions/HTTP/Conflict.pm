package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::Conflict;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {409}
sub message     {'Conflict'}

1;

