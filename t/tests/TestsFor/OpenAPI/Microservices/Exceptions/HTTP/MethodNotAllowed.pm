package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::MethodNotAllowed;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {405}
sub message     {'Method Not Allowed'}

1;

