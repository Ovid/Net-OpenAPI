package TestsFor::Net::OpenAPI::Exceptions::HTTP::PreconditionFailed;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {412}
sub message     {'Precondition Failed'}

__PACKAGE__->meta->make_immutable;

