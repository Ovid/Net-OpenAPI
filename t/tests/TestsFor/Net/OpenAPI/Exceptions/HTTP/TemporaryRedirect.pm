package TestsFor::Net::OpenAPI::Exceptions::HTTP::TemporaryRedirect;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {307}
sub message     {'Temporary Redirect'}

1;
