package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::PermanentRedirect;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {308}
sub message     {'Permanent Redirect'}

1;

