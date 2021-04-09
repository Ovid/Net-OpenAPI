package TestsFor::Net::OpenAPI::Builder::Controller;

# vim: textwidth=200

use Net::OpenAPI::Builder;
use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_controller {
    my $test = shift;

    my $builder = Net::OpenAPI::Builder->new(
        schema_file => 'data/v3-petstore.json',
        dir         => '/tmp',
        base        => 'do::not::reuse::this::package::name::in::noncontroller::tests',
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
                my $method      = $route->{method};
                ok $package->can($method), "'$http_method $path' should map to the existing function '$method'";
            }
        };
    }
}

__PACKAGE__->meta->make_immutable;
