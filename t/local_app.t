#!/usr/bin/env perl

use Test::Most;
use Plack::Test;
use HTTP::Request::Common;
use Net::OpenAPI::App::StatusCodes qw(HTTPOK HTTPNotImplemented HTTPNotFound);
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::JSON ':all';
use lib 'lib', 't/test_app/lib';
use My::Project::OpenAPI::App;    # in t/test_app

my $app;
{
    use Plack::Builder;
    $app = builder {
        enable "Plack::Middleware::Static", path => qr{^/openapi/.+\.(?:json|yaml)$}, root => '.';
        mount '/api/v1'   => builder { My::Project::OpenAPI::App->get_app };
        mount '/api/docs' => builder { My::Project::OpenAPI::App->doc_index };
    };
}

my $plack = Plack::Test->create($app);

ok my $res = $plack->request( GET '/api/v1/pet/3' ), 'We should be able to try to fetch a pet';
is $res->code, HTTPOK, '... and get something valid';

my $expected = {
    'category' => {
        'id'   => 1,
        'name' => 'Dogs'
    },
    'id'        => '3',
    'name'      => 'doggie',
    'photoUrls' => ['string'],
    'status'    => 'available',
    'tags'      => [ {} ]
};
eq_or_diff decode_json( $res->content ), $expected, '... and get the correct data';

ok $res = $plack->request( PUT '/api/pet/3' ), 'We should be able to send a message to a non-existent route';
is $res->code, HTTPNotFound, '... but get a Not Found error';

done_testing;
