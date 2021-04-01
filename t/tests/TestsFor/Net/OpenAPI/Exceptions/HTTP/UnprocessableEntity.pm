package TestsFor::Net::OpenAPI::Exceptions::HTTP::UnprocessableEntity;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {422}
sub message     {'Unprocessable Entity'}

1;

