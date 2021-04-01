package TestsFor::Net::OpenAPI::Exceptions::HTTP::Found;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {302}
sub message     {'Found'}

1;

