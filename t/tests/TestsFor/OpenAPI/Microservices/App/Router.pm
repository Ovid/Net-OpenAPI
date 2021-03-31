package TestsFor::OpenAPI::Microservices::App::Router;

use OpenAPI::Microservices::Policy;
use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';

sub test_routing {
    my $test   = shift;
    my $router = $test->class_name->new;
    my @routes = (
        { path => '/pet',              http_method => 'post',   dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'post' },
        { path => '/pet',              http_method => 'put',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'put' },
        { path => '/pet/findByStatus', http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'get_findByStatus' },
        { path => '/pet/findByTags',   http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'get_findByTags' },
        { path => '/pet/{petId}',      http_method => 'delete', dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'with_args_delete' },
        { path => '/pet/{petId}',      http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'with_args_get' },
        { path => '/pet/{petId}',      http_method => 'post',   dispatch_to => 'My::Project::OpenAPI::Model::Pet', method => 'with_args_post' },
        {
            path   => '/pet/{petId}/uploadImage', http_method => 'post', dispatch_to => 'My::Project::OpenAPI::Model::Pet',
            method => 'with_args_post___uploadImage'
        },
        { path => '/日本/{city}', http_method => 'get', dispatch_to => 'My::Project::OpenAPI::Model::RiBen', method => 'with_args_get' },
    );
    foreach my $route (@routes) {
        my ( $method, $path ) = @{$route}{qw/http_method path/};
        ok $router->add_route($route), "We should be able to add routes to our router: $method $path";
    }
    throws_ok { $router->add_route( $routes[0] ) }
    qr{Route for POST /pet already added},
      'Trying to add a duplicate route should fail';
}

__PACKAGE__->meta->make_immutable;
