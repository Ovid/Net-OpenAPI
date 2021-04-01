package TestsFor::Net::OpenAPI::Exceptions::HTTP::NotFound;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {404}
sub message     {'Not Found'}

1;

