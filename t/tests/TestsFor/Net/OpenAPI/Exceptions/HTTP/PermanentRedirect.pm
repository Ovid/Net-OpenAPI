package TestsFor::Net::OpenAPI::Exceptions::HTTP::PermanentRedirect;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {308}
sub message     {'Permanent Redirect'}

__PACKAGE__->meta->make_immutable;

