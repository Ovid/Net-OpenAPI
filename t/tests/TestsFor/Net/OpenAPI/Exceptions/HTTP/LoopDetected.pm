package TestsFor::Net::OpenAPI::Exceptions::HTTP::LoopDetected;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {508}
sub message     {'Loop Detected'}

__PACKAGE__->meta->make_immutable;

