package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::ProxyAuthenticationRequired;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {407}
sub message     {'Proxy Authentication Required'}

1;

