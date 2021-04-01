package TestsFor::Net::OpenAPI::Exceptions::HTTP::UnavailableForLegalReasons;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {451}
sub message     {'Unavailable For Legal Reasons'}

__PACKAGE__->meta->make_immutable;

