package TestsFor::Net::OpenAPI::Exceptions::HTTP::FailedDependency;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {424}
sub message     {'Failed Dependency'}

1;

