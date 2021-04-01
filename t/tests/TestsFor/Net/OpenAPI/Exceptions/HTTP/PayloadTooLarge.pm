package TestsFor::Net::OpenAPI::Exceptions::HTTP::PayloadTooLarge;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {413}
sub message     {'Payload Too Large'}

1;

