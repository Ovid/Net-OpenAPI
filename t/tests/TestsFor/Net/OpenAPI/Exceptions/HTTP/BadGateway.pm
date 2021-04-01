package TestsFor::Net::OpenAPI::Exceptions::HTTP::BadGateway;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {502}
sub message     {'Bad Gateway'}

__PACKAGE__->meta->make_immutable;

