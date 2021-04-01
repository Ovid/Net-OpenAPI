package TestsFor::Net::OpenAPI::Exceptions::HTTP::TooManyRequests;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {429}
sub message     {'Too Many Requests'}

__PACKAGE__->meta->make_immutable;

