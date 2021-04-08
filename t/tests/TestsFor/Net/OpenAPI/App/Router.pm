package TestsFor::Net::OpenAPI::App::Router;

use Plack::Request;
use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_routing {
    my $test   = shift;
    my @routes = (
        { path => '/pet', http_method => 'post', controller => 'My::Project::OpenAPI::Model::Pet', method => 'post' },
        { path => '/pet', http_method => 'post', controller => 'My::Project::OpenAPI::Model::Pet', method => 'post' },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        QUERY_STRING   => 'query=%82%d9%82%b0',    # <= encoded by 'cp932'
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/get',
    };
    my $req = Plack::Request->new($env);
    throws_ok { $router->match($req) }
    qr{Route for POST /pet already registered},
      'Trying to add a duplicate route should fail';
}

sub test_match {
    my $test = shift;

    package Example::Package::For::Dispatch {
        sub foo { return 42 }
    }
    $INC{'Example/Package/For/Dispatch.pm'} = 1;    # fake loading it
    my @routes = (
        { path => '/get', http_method => 'get', controller => 'Example::Package::For::Dispatch', method => 'foo' },
        { path => '/put', http_method => 'put', controller => 'Example::Package::For::Dispatch', method => 'no_such_sub' },
        { path => '/foo', http_method => 'get', controller => 'No::Such::Package::Is::Here',     method => 'no_such_sub' },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        QUERY_STRING   => 'query=%82%d9%82%b0',     # <= encoded by 'cp932'
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/get',
    };
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

sub test_ambiguous_matches {
    my $test = shift;

    package Example::Package::For::Dispatch {
        use Net::OpenAPI::App::Endpoint;

        endpoint 'get /pet/findByStatus' => sub {'get_findByStatus'};
        endpoint 'get /pet/findByTags'   => sub {'get_findByTags'};
        endpoint 'get /pet/{petId}'      => sub {'with_args_get'};
    }
    $INC{'Example/Package/For/Dispatch.pm'} = 1;    # fake loading it
    my @routes = (
        { path => '/pet/findByStatus', http_method => 'get', controller => 'Example::Package::For::Dispatch', method => 'get_findByStatus' },
        { path => '/pet/findByTags',   http_method => 'get', controller => 'Example::Package::For::Dispatch', method => 'get_findByTags' },
        { path => '/pet/{petId}',      http_method => 'get', controller => 'Example::Package::For::Dispatch', method => 'with_args_get' },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/pet/3',
    };
    my $req   = Plack::Request->new($env);
    my $match = $router->match($req);
    is $match->{dispatch}->($req), 'with_args_get', 'We should be able to dispatch directly to subs';
    eq_or_diff $match->{uri_params}, { petId => 3 },
      '... and we should get our uri_params returned, too';
}
__PACKAGE__->meta->make_immutable;
