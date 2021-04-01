package TestsFor::Net::OpenAPI::Exceptions::HTTP::ServiceUnavailable;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {503}
sub message     {'Service Unavailable'}

__PACKAGE__->meta->make_immutable;

