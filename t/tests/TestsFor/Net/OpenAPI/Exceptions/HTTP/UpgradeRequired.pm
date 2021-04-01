package TestsFor::Net::OpenAPI::Exceptions::HTTP::UpgradeRequired;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {426}
sub message     {'Upgrade Required'}

1;

