package TestsFor::Net::OpenAPI::Exceptions::HTTP::InternalServerError;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {500}
sub message     {'Internal Server Error'}

1;

