package TestsFor::Net::OpenAPI::Exceptions::HTTP::RequestedRangeNotSatisfiable;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {416}
sub message     {'Requested Range Not Satisfiable'}

1;

