package TestsFor::Net::OpenAPI::Builder::Controller;

# vim: textwidth=200

use Net::OpenAPI::Builder;
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::StatusCodes qw(HTTPNotImplemented);
use Net::OpenAPI::Utils::Core qw(
  path_router_to_openapi
);
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
with 'Test::Net::OpenAPI::Role::Tempdir';

sub test_controller {
    my $test = shift;

    my $builder = Net::OpenAPI::Builder->new(
        schema_file => 'data/v3-petstore.json',
        dir         => $test->tempdir,
        base        => 'do::not::reuse::this::package::name::in::noncontroller::tests',
        api_base    => '/api/v1',
        doc_base    => '/api/docs',
    );
    my $controllers = $builder->controllers;
    foreach my $controller ( @{$controllers} ) {
        my $package = $controller->package;
        my $name    = $controller->name;
        subtest "Controller for $name" => sub {
            ok my $code = $controller->code, 'We should be able to fetch the code for a controller';
            eval $code;
            my $error = $@;
            ok !$error, '... and we should be able to compile it' or die "Error: $error";
            ok my $routes = $package->routes,
              '... and we should be able to fetch our routes from the package';
            foreach my $path ( keys %$routes ) {
                my $dispatch = $routes->{$path};
                foreach my $method ( keys %$dispatch ) {
                    my $action   = $dispatch->{$method};
                    my $response = $action->();
                    ok $response->isa('Net::OpenAPI::App::Response'), 'Default action behavior is to return a response object';
                    is $response->status_code, HTTPNotImplemented, '... with the "not implemented" response code';
                    eq_or_diff $response->body, { error => 'Not Implemented', code => HTTPNotImplemented, info => path_router_to_openapi("$method $path" )},
                      '... and a response body suitable for serialization into JSON';
                }
            }
        };
    }
}

__PACKAGE__->meta->make_immutable;
