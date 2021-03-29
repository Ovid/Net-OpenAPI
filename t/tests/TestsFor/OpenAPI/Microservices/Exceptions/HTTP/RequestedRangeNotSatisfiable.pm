package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::RequestedRangeNotSatisfiable;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {416}
sub message     {'Requested Range Not Satisfiable'}

1;

