package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::TemporaryRedirect;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {307}
sub message     {'Temporary Redirect'}

1;

