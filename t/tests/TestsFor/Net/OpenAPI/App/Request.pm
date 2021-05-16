package TestsFor::Net::OpenAPI::App::Request;

# vim: textwidth=200

use Net::OpenAPI::App::JSON 'decode_json';
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::StatusCodes qw(HTTPOK);
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
with 'Test::Net::OpenAPI::Role::Request';

sub test_basics {
    my $test = shift;
    $DB::single = 1;
    ok my $req = $test->get_request( get => '/api/v1/pet/5?foo=bar&baz=42' ), 'We should be able to fetch a request';
    my $path_info = $req->path_info;
    my $query     = $req->query_parameters;

    is $req->method, 'GET', '... and get the correct method';
    is $req->path_info, '/api/v1/pet/5?foo=bar&baz=42', '... and get the correct path info';
    eq_or_diff [ $query->get_all('foo') ], ['bar'], '... we should be able to get our query params';
    eq_or_diff [ $query->get_all('baz') ], [42],    '... we should be able to get our query params';
    my $headers = [
        'Connection'                => 'keep-alive',
        'Accept'                    => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Encoding'           => 'gzip, deflate',
        'Accept-Language'           => 'en-US,en;q=0.5',
        'Host'                      => '0.0.0.0:5000',
        'User-Agent'                => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:87.0) Gecko/20100101 Firefox/87.0',
        'Upgrade-Insecure-Requests' => '1'
    ];
    eq_or_diff $req->headers->psgi_flatten, $headers, '... and we should have the correct headers';
    explain [ $req->validation_data ];
}

__PACKAGE__->meta->make_immutable;

__END__
