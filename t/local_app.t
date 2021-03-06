#!/usr/bin/env perl

use lib 'lib', 't/test_app/lib';

use Test::Most;
use Plack::Test;
use HTTP::Request::Common;

use Net::OpenAPI::App::JSON ':all';
use Net::OpenAPI::App::StatusCodes qw(HTTPOK HTTPNotImplemented HTTPNotFound);
use Net::OpenAPI::Builder;
use Net::OpenAPI::Policy;

BEGIN {
    explain <<'END';
We use the builder to deliberately rewrite our test application every time
this test is run. That way, we can verify that local changes we make to the
application are not overwritten.

Note: if we've done this correctly, this should result in *no* changes to the
files. If git says something has changed in t/test_app/ and we weren't expecting
it, it's time to investigate.
END
    Net::OpenAPI::Builder->new(
        schema_file => 'data/v3-petstore.json',
        base        => 'My::Project::OpenAPI',
        dir         => 't/test_app',
        api_base    => '/api/v1',
        doc_base    => '/api/docs',
    )->write;
}
use My::Project::OpenAPI::App;    # in t/test_app
pass;
done_testing; exit;

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
    category => {
        id   => 1,
        name => 'Dogs'
    },
    id        => 3,
    name      => 'doggie',
    photoUrls => ['string'],
    status    => 'available',
    tags      => [ {} ]
};
eq_or_diff decode_json( $res->content ), $expected, '... and get the correct data';

$expected->{id} = 17;
ok $res = $plack->request( GET '/api/v1/pet/17' ), 'We should be able to try to fetch a pet';
is $res->code, HTTPOK, '... and get something valid';
eq_or_diff decode_json( $res->content ), $expected, '... and get the correct data';

ok $res = $plack->request( PUT '/api/pet/3' ), 'We should be able to send a message to a non-existent route';
is $res->code, HTTPNotFound, '... but get a Not Found error';

done_testing;
