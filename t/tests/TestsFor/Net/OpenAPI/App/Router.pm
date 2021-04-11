package TestsFor::Net::OpenAPI::App::Router;

use Plack::Request;
use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_routing {
    my $test   = shift;
    my @routes = (
        {
            '/pet' => {
                post => sub { },
            },
        },
        {
            '/pet' => {
                post => sub { },
            },
        },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        QUERY_STRING   => 'query=%82%d9%82%b0',    # <= encoded by 'cp932'
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/get',
    };
    my $req = Plack::Request->new($env);
    $test->todo_start("We do not yet match duplicate requests");
    throws_ok { $router->match($req) }
    qr{Route for POST /pet already registered},
      'Trying to add a duplicate route should fail';
}

sub test_match {
    my $test = shift;

    my @routes = (
        {
            '/get' => {
                get => sub {'get me'}
            }
        },
        {
            '/put' => {
                put => sub {'put me'}
            }
        },
        {
            '/foo' => {
                get => sub {'get me 2'}
            }
        },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        QUERY_STRING   => 'query=%82%d9%82%b0',    # <= encoded by 'cp932'
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/get',
    };
    my $req = Plack::Request->new($env);
    my ( $action, $match ) = $router->match($req);
    is $action->($req), 'get me', 'We should be able to dispatch directly to subs';

    $env->{PATH_INFO} = '/nope';
    $req = Plack::Request->new($env);
    ok !$router->match($req), '... but we cannot match to non-existent routes';
}

sub test_passing_data_to_endpoints {
    my $test = shift;

    my @routes = (
        {
            '/pet/:petId' => {
                get => sub {
                    my ( $req, $match ) = @_;
                    return { petId => $match->mapping->{petId} };
                },
            }
        },
        {
            '/put' => {
                put => sub {'put me'}
            }
        },
        {
            '/foo' => {
                get => sub {'get me 2'}
            }
        },
    );
    my $router = $test->class_name->new( routes => \@routes );
    my $env    = {
        REQUEST_METHOD => 'GET',
        HTTP_HOST      => 'example.com',
        PATH_INFO      => '/pet/3',
    };
    my $req = Plack::Request->new($env);
    my ( $action, $match ) = $router->match($req);
    ok my $result = $action->( $req, $match ), 'We should be able to dispatch directly to subs';
    eq_or_diff $result, { petId => 3 },
      '... and we should get our uri_params returned, too';
}

__PACKAGE__->meta->make_immutable;
