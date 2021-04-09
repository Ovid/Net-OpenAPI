package TestsFor::Net::OpenAPI::Builder::Controller;

# vim: textwidth=200

use Net::OpenAPI::Builder;
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::StatusCodes qw(HTTPNotImplemented);
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

use Net::OpenAPI::App::Types qw(
  Directory
);
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

sub test_controller {
    my $test = shift;

    my $builder = Net::OpenAPI::Builder->new(
        schema_file => 'data/v3-petstore.json',
        dir         => $test->_tmpdir,
        base        => 'do::not::reuse::this::package::name::in::noncontroller::tests',
        api_base    => '/api/v1',
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
            foreach my $route (@$routes) {
                my $http_method = $route->{http_method};
                my $path        = $route->{path};
                my $action_name = $route->{action};
                ok my $action = $package->can($action_name), "'$http_method $path' should map to the existing function '$action_name'";
                my $response = $action->();
                ok $response->isa('Net::OpenAPI::App::Response'), 'Default action behavior is to return a response object';
                is $response->status_code, HTTPNotImplemented, '... with the "not implemented" response code';
                eq_or_diff $response->body, { error => 'Not Implemented', code => HTTPNotImplemented, info => "$http_method $path" },
                  '... and a response body suitable for serialization into JSON';
            }
        };
    }
}

__PACKAGE__->meta->make_immutable;
