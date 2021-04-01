package TestsFor::Net::OpenAPI::Exceptions::HTTP::Unauthorized;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {401}
sub message     {'Unauthorized'}

1;

