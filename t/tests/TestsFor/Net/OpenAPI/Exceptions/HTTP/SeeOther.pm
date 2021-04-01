package TestsFor::Net::OpenAPI::Exceptions::HTTP::SeeOther;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {303}
sub message     {'See Other'}

__PACKAGE__->meta->make_immutable;

