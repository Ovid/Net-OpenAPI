package TestsFor::Net::OpenAPI::Exceptions::HTTP::Locked;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {423}
sub message     {'Locked'}

__PACKAGE__->meta->make_immutable;

