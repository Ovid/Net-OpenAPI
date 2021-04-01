package TestsFor::Net::OpenAPI::App::Endpoint;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';

package Example::Package::For::Endpoints {
    use Net::OpenAPI::App::Endpoint;

    endpoint 'GET /pet/{petId}' => sub {
        return 'this is GET /pet/{petId}';
    };
}

sub test_endpoint {
    my $test = shift;

    ok my $code = Example::Package::For::Endpoints->can('with_args_get'),
        'endpoint() should rewrap our function names';
    is $code->(), 'this is GET /pet/{petId}', '... and it should do what we expect';
}

1;
