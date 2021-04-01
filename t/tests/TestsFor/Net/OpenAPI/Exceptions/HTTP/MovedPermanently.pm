package TestsFor::Net::OpenAPI::Exceptions::HTTP::MovedPermanently;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {301}
sub message     {'Moved Permanently'}

1;

