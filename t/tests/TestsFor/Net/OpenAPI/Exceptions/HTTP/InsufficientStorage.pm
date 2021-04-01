package TestsFor::Net::OpenAPI::Exceptions::HTTP::InsufficientStorage;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {507}
sub message     {'Insufficient Storage'}

1;

