package TestsFor::Net::OpenAPI::Exceptions::HTTP::VariantAlsoNegotiates;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {506}
sub message     {'Variant Also Negotiates'}

1;

