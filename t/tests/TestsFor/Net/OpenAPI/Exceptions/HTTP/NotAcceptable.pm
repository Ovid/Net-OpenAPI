package TestsFor::Net::OpenAPI::Exceptions::HTTP::NotAcceptable;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {406}
sub message     {'Not Acceptable'}

__PACKAGE__->meta->make_immutable;

