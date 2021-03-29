package TestsFor::OpenAPI::Microservices::Exceptions::HTTP::ClientClosedRequest;

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use Moose;
with 'Test::OpenApi::Microservices::Exceptions::Role::HTTP';

sub status_code {499}
sub message     {'Client Closed Request'}

1;

