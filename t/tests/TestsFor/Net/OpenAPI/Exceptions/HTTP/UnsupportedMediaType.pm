package TestsFor::Net::OpenAPI::Exceptions::HTTP::UnsupportedMediaType;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {415}
sub message     {'Unsupported Media Type'}

1;

