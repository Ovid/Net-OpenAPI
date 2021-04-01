package TestsFor::Net::OpenAPI::Exceptions::HTTP::RequestTimeout;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {408}
sub message     {'Request Timeout'}

1;

