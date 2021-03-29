package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::UnsupportedMediaType;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {415}
sub message     {'Unsupported Media Type'}

1;

