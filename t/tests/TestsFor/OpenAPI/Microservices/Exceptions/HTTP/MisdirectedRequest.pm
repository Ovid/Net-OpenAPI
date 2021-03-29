package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::MisdirectedRequest;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {421}
sub message     {'Misdirected Request'}

1;

