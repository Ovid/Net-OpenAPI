package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::MultipleChoices;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {300}
sub message     {'Multiple Choices'}

1;

