package TestsFor::Net::OpenAPI::App::Validator;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_serialization {
    my $test = shift;
    ok my $validator = $test->class_name->new( schema => 'data/v3-petstore.json' ),
      'We should be able to create our validator object';
    my $expected = {
        'properties' => {
            'category' => {
                'properties' => {
                    'id'   => { 'example' => 1,      'format' => 'int64', 'type' => 'integer' },
                    'name' => { 'example' => 'Dogs', 'type'   => 'string' }
                },
                'type' => 'object',
                'xml'  => { 'name' => 'category' }
            },
            'id'        => { 'example' => 10,       'format' => 'int64', 'type' => 'integer' },
            'name'      => { 'example' => 'doggie', 'type'   => 'string' },
            'photoUrls' => {
                'items' => { 'type' => 'string', 'xml' => { 'name' => 'photoUrl' } },
                'type'  => 'array',
                'xml'   => { 'wrapped' => 1 }
            },
            'status' => {
                'description' => 'pet status in the store',
                'enum'        => [ 'available', 'pending', 'sold' ],
                'type'        => 'string'
            },
            'tags' => {
                'items' => {
                    'properties' => {
                        'id'   => { 'format' => 'int64', 'type' => 'integer' },
                        'name' => { 'type'   => 'string' }
                    },
                    'type' => 'object',
                    'xml'  => { 'name' => 'tag' }
                },
                'type' => 'array',
                'xml'  => { 'wrapped' => 1 }
            }
        },
        'required' => [ 'name', 'photoUrls' ],
        'type'     => 'object',
        'xml'      => { 'name' => 'pet' }
    };
    eq_or_diff $validator->get_component( 'components', 'schemas', 'Pet' ),
      $expected,
      'We should be aable to full resolve a component';
}

__PACKAGE__->meta->make_immutable;

__END__
