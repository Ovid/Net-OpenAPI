package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::LengthRequired;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {411}
sub message     {'Length Required'}

1;

