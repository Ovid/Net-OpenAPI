package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::UnavailableForLegalReasons;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {451}
sub message     {'Unavailable For Legal Reasons'}

1;

