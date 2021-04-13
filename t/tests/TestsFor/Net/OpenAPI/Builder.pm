package TestsFor::Net::OpenAPI::Builder;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
with 'Test::Net::OpenAPI::Role::Tempdir';

sub test_basics {
    my $test = shift;

    my $builder = $test->class_name->new(
        schema_file => 'data/v3-petstore.json',
        dir         => $test->tempdir,
        base        => 'Some::OpenAPI::Project',
        api_base    => '/api/v1',
        doc_base    => '/api/docs',
    );
    ok $builder->write, 'We should be able to write our code';
}

__PACKAGE__->meta->make_immutable;
