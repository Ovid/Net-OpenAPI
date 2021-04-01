package TestsFor::Net::OpenAPI::Exceptions::HTTP::ClientClosedRequest;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {499}
sub message     {'Client Closed Request'}

1;

