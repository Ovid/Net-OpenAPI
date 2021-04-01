package TestsFor::Net::OpenAPI::Exceptions::HTTP::PreconditionRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {428}
sub message     {'Precondition Required'}

1;

