package TestsFor::Net::OpenAPI::Exceptions::HTTP::RequestHeaderFieldsTooLarge;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {431}
sub message     {'Request Header Fields Too Large'}

1;

