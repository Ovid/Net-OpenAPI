package TestsFor::Net::OpenAPI::Exceptions::HTTP::ExpectationFailed;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {417}
sub message     {'Expectation Failed'}

__PACKAGE__->meta->make_immutable;

