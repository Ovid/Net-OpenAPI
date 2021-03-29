package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::VariantAlsoNegotiates;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {506}
sub message     {'Variant Also Negotiates'}

1;

