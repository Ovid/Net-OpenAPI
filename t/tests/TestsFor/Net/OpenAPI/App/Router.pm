package TestsFor::Net::OpenAPI::App::Router;

use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_routing {
    my $test   = shift;
    my $router = $test->class_name->new;
    my @routes = (
        { path => '/pet',              http_method => 'post',   dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'post' },
        { path => '/pet',              http_method => 'put',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'put' },
        { path => '/pet/findByStatus', http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'get_findByStatus' },
        { path => '/pet/findByTags',   http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'get_findByTags' },
        { path => '/pet/{petId}',      http_method => 'delete', dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'with_args_delete' },
        { path => '/pet/{petId}',      http_method => 'get',    dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'with_args_get' },
        { path => '/pet/{petId}',      http_method => 'post',   dispatch_to => 'My::Project::OpenAPI::Model::Pet', action => 'with_args_post' },
        {
            path   => '/pet/{petId}/uploadImage', http_method => 'post', dispatch_to => 'My::Project::OpenAPI::Model::Pet',
            action => 'with_args_post___uploadImage'
        },
        { path => '/日本/{city}', http_method => 'get', dispatch_to => 'My::Project::OpenAPI::Model::RiBen', action => 'with_args_get' },
    );
    foreach my $route (@routes) {
        my ( $method, $path ) = @{$route}{qw/http_method path/};
        ok $router->add_route($route), "We should be able to add routes to our router: $method $path";
    }
    throws_ok { $router->add_route( $routes[0] ) }
    qr{Route for POST /pet already added},
      'Trying to add a duplicate route should fail';
}

sub test_match {
    my $test = shift;

    package Example::Package::For::Dispatch {
        sub foo { return 42 }
    }
    $INC{'Example/Package/For/Dispatch.pm'} = 1;    # fake loading it
    my $router = $test->class_name->new;
    my @routes = (
        { path => '/get', http_method => 'get', dispatch_to => 'Example::Package::For::Dispatch', action => 'foo' },
        { path => '/put', http_method => 'put', dispatch_to => 'Example::Package::For::Dispatch', action => 'no_such_sub' },
        { path => '/foo', http_method => 'get', dispatch_to => 'No::Such::Package::Is::Here',     action => 'no_such_sub' },
    );
    foreach my $route (@routes) {
        my ( $method, $path ) = @{$route}{qw/http_method path/};
        ok $router->add_route($route), "We should be able to add routes to our router: $method $path";
    }
    my $env = {
        QUERY_STRING   => 'query=%82%d9%82%b0',     # <= encoded by 'cp932'
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/get',
    };
    use Plack::Request;
    my $req   = Plack::Request->new($env);
    my $match = $router->match($req);
    is $match->{dispatch}->($req), 42, 'We should be able to dispatch directly to subs';

    $env->{PATH_INFO} = '/nope';
    $req = Plack::Request->new($env);
    ok !$router->match($req), '... but we cannot match to non-existent routes';

    $env->{PATH_INFO}      = '/put';
    $env->{REQUEST_METHOD} = 'PUT';
    $req                   = Plack::Request->new($env);
    throws_ok { $router->match($req) }
    qr/Cannot dispatch to non-existent sub \(Example::Package::For::Dispatch::no_such_sub\)/,
      '... but dispatching to a sub we cannot find should fail';

    $env->{PATH_INFO}      = '/foo';
    $env->{REQUEST_METHOD} = 'GET';
    $req                   = Plack::Request->new($env);
    throws_ok { $router->match($req) }
    qr/Can't locate.*in \@INC/,
      '... and dispatching to a module we cannot load should fail';
}

__PACKAGE__->meta->make_immutable;
