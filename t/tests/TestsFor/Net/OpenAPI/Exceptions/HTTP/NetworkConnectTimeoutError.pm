package TestsFor::Net::OpenAPI::Exceptions::HTTP::NetworkConnectTimeoutError;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {599}
sub message     {'Network Connect Timeout Error'}

__PACKAGE__->meta->make_immutable;

