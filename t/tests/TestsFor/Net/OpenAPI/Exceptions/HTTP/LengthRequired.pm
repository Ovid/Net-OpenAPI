package TestsFor::Net::OpenAPI::Exceptions::HTTP::LengthRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {411}
sub message     {'Length Required'}

1;

