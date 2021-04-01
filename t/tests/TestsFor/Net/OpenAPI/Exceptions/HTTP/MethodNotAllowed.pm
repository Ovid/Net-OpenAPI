package TestsFor::Net::OpenAPI::Exceptions::HTTP::MethodNotAllowed;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {405}
sub message     {'Method Not Allowed'}

__PACKAGE__->meta->make_immutable;

