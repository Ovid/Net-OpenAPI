package TestsFor::Net::OpenAPI::Exceptions::HTTP::ProxyAuthenticationRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {407}
sub message     {'Proxy Authentication Required'}

1;

