package TestsFor::Net::OpenAPI::Exceptions::HTTP::Forbidden;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {403}
sub message     {'Forbidden'}

1;

