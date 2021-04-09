package TestsFor::Net::OpenAPI::Builder;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  Directory
);
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use File::Temp qw(tempdir);
use File::Path qw(rmtree);

has _tmpdir => (
    is      => 'ro',
    isa     => Directory,
    default => tempdir('/tmp/net_open_api_XXXXXXX'),
);

sub DEMOLISH {
    my $test = shift;
    rmtree( $test->_tmpdir );
}

sub test_basics {
    my $test = shift;

    my $builder = $test->class_name->new(
        schema_file => 'data/v3-petstore.json',
        dir         => $test->_tmpdir,
        base        => 'Some::OpenAPI::Project',
        api_base    => '/api/v1',
    );
    ok $builder->write, 'We should be able to write our code';
}

__PACKAGE__->meta->make_immutable;
