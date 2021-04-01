package TestsFor::Net::OpenAPI::Exceptions::HTTP::RequestURITooLong;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {414}
sub message     {'Request-URI Too Long'}

1;

