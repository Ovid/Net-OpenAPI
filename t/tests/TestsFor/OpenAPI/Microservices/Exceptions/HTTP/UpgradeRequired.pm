package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::UpgradeRequired;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {426}
sub message     {'Upgrade Required'}

1;

