package TestsFor::Net::OpenAPI::Exceptions::HTTP::MisdirectedRequest;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {421}
sub message     {'Misdirected Request'}

1;

