package TestsFor::Net::OpenAPI::Exceptions::HTTP::MultipleChoices;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {300}
sub message     {'Multiple Choices'}

1;

