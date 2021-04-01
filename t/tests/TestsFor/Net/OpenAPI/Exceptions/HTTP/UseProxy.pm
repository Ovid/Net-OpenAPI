package TestsFor::Net::OpenAPI::Exceptions::HTTP::UseProxy;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {305}
sub message     {'Use Proxy'}

__PACKAGE__->meta->make_immutable;

