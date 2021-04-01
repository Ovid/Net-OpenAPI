package TestsFor::Net::OpenAPI::Exceptions::HTTP::HTTPVersionNotSupported;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {505}
sub message     {'HTTP Version Not Supported'}

__PACKAGE__->meta->make_immutable;

