#!/usr/bin/env perl

use Test::Most;
use Plack::Test;
use HTTP::Request::Common;
use Net::OpenAPI::App::StatusCodes qw(HTTPOK HTTPNotImplemented HTTPNotFound);
use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder;
use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile);
use Net::OpenAPI::App::JSON qw(:all);
use lib 'lib', 't/lib';

explain <<'END';
This test is in a .t file rather than in the xUnit tests because we have a "do
$psgi" at one point. That litters our namespace with a bunch of extra code and
we would like to isolate that from the xUnit tests.
END

my $tempdir = File::Temp->newdir;
my $builder = Net::OpenAPI::Builder->new(
    schema_file => 'data/v3-petstore.json',
    dir         => $tempdir,
    base        => 'Some::OpenAPI::Project',
    api_base    => '/api/v1',
    doc_base    => '/api/docs',
);
ok $builder->write, 'We should be able to write our code';

my $psgi = catfile( $tempdir, 'script', 'app.psgi' );
ok -e $psgi, 'We should have a psgi app created';

my $app;
my $success = eval {
    $app = do $psgi;
    1;
};
ok $success, 'we should be able to "do" our app';

my $plack = Plack::Test->create($app);

my $res = $plack->request( GET "/api/docs" );
like $res->content, qr/Some::OpenAPI::Project OpenAPI documentation/,
  'We should be able to fetch our docs page';
is $res->code, HTTPOK, '... and get an OK status';
is $res->content_type, 'text/html', '... and it should be an HTML document';

ok $res = $plack->request( GET '/api/v1/pet/3' ), 'We should be able to try to fetch something valid';
is $res->code, HTTPNotImplemented, '... but get a Not Implemented error';

my $expected = {
    'code'  => 501,
    'error' => 'Not Implemented',
    'info'  => 'get /pet/{petId}'
};
eq_or_diff decode_json( $res->content ), $expected, '... and a JSON body explaining what is going on';

ok $res = $plack->request( PUT '/api/pet/3' ), 'We should be able to send a message to a non-existent route';
is $res->code, HTTPNotFound, '... but get a Not Found error';

done_testing;
