package TestsFor::Net::OpenAPI::Exceptions::HTTP::NotModified;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {304}
sub message     {'Not Modified'}

1;

