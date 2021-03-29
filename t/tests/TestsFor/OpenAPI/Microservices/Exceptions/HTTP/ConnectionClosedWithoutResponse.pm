package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::ConnectionClosedWithoutResponse;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {444}
sub message     {'Connection Closed Without Response'}

1;

