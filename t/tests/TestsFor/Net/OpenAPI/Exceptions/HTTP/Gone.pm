package TestsFor::Net::OpenAPI::Exceptions::HTTP::Gone;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {410}
sub message     {'Gone'}

1;

