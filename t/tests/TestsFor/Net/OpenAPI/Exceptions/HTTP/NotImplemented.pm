package TestsFor::Net::OpenAPI::Exceptions::HTTP::NotImplemented;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {501}
sub message     {'Not Implemented'}

1;

