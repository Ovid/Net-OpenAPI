package TestsFor::Net::OpenAPI::Builder;

# vim: textwidth=200

use File::Spec::Functions qw(catfile);
use Plack::Test;
use HTTP::Request::Common;

use Net::OpenAPI::App::StatusCodes qw(:all);
use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
with 'Test::Net::OpenAPI::Role::Tempdir';

sub test_basics {
    my $test = shift;

    my $builder = $test->class_name->new(
        schema_file => 'data/v3-petstore.json',
        dir         => $test->tempdir,
        base        => 'Some::OpenAPI::Project',
        api_base    => '/api/v1',
        doc_base    => '/api/docs',
    );
    ok $builder->write, 'We should be able to write our code';
}

sub test_generated_app {
    my $test = shift;

    my $tempdir = $test->tempdir;
    my $builder = $test->class_name->new(
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

    # XXX I would test this, but I want us to standardize on a JSON decode/encode solution first
    explain $res->content;

    ok $res = $plack->request( PUT '/api/pet/3' ), 'We should be able to send a message to a non-existent route';
    is $res->code, HTTPNotFound, '... but get a Not Found error';
}

__PACKAGE__->meta->make_immutable;
