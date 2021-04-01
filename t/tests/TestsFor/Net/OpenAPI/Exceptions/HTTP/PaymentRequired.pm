package TestsFor::Net::OpenAPI::Exceptions::HTTP::PaymentRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {402}
sub message     {'Payment Required'}

__PACKAGE__->meta->make_immutable;

