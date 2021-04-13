package TestsFor::Net::OpenAPI::Utils::File;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Utils::File qw(:all);

sub test_utils {
    my $test  = shift;
    my $stuff = slurp('data/v3-petstore.json');
    ok $stuff, 'We should be able to read files';
    throws_ok { slurp('no such file') }
    qr/No such file or directory/,
      '... but trying to slurp a non-existent file should fail';
}

__PACKAGE__->meta->make_immutable;
