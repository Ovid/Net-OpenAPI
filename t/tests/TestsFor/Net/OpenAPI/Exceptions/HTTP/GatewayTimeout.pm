package TestsFor::Net::OpenAPI::Exceptions::HTTP::GatewayTimeout;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {504}
sub message     {'Gateway Timeout'}

1;
