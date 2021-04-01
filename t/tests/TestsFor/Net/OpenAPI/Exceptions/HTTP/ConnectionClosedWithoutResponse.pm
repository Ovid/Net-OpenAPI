package TestsFor::Net::OpenAPI::Exceptions::HTTP::ConnectionClosedWithoutResponse;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {444}
sub message     {'Connection Closed Without Response'}

__PACKAGE__->meta->make_immutable;

