package Test::Net::OpenAPI::Role::Request;

# ABSTRACT: Requests

use Moose::Role;

use Net::OpenAPI::App::Request;
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
    compile
    HTTPMethod
    NonEmptyStr
);
    

sub get_request {
    my ( $test, $method, $path, %overrides ) = @_;

    my %defaults = (
        'HTTP_ACCEPT'                    => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'HTTP_ACCEPT_ENCODING'           => 'gzip, deflate',
        'HTTP_ACCEPT_LANGUAGE'           => 'en-US,en;q=0.5',
        'HTTP_CONNECTION'                => 'keep-alive',
        'HTTP_HOST'                      => '0.0.0.0:5000',
        'HTTP_UPGRADE_INSECURE_REQUESTS' => '1',
        'HTTP_USER_AGENT'                => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:87.0) Gecko/20100101 Firefox/87.0',
        'PATH_INFO'                      => '/pet/5',
        'QUERY_STRING'                   => 'foo=bar&baz=42',
        'REMOTE_ADDR'                    => '127.0.0.1',
        'REMOTE_PORT'                    => 62853,
        'REQUEST_METHOD'                 => 'GET',
        'REQUEST_URI'                    => '/v1/pet/5?foo=bar&baz=42',
        'SCRIPT_NAME'                    => '/api/v1',
        'SERVER_NAME'                    => 0,
        'SERVER_PORT'                    => 5000,
        'SERVER_PROTOCOL'                => 'HTTP/1.1',
    );
    state $check = compile(HTTPMethod, NonEmptyStr);
    ($method,$path) = $check->($method, $path);
    $defaults{REQUEST_METHOD} = uc $method;
    $defaults{PATH_INFO}      = $path;
    while ( my ($k,$v) = each %overrides) {
        $k = uc $k;
        unless (exists $defaults{$k} ) {
            carp("Generating request with unknown key: $k");
        }
        $defaults{$k} = $v;
    }
    return Net::OpenAPI::App::Request->new(env => \%defaults);
}

1;

__END__

=head1 SYNOPSIS

    package TestsFor::Net::OpenAPI::Some::Test;

    use Test::Class::Moose extends => 'Test::Net::OpenAPI';
    with 'Test::Net::OpenAPI::Role::Request';

    sub test_basics {
        my $test = shift;
        my $request = $test->get_request( GET => '/api/v1/pet' );
        my $request = $test->get_request( GET => '/api/v1/pet' );

        ... write tests
    }

    __PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

Provides "per test method" temp directories that are guaranteed to be cleaned up.

=head1 METHODS

=head2 C<tempdir>

    my $tempdir = $test->tempdir;

Returns a new temp directory. Always returns the same temp directory for a
given method, unless C<remove_tempdir> is called, in which case a new temp
directory is generated:

    my $tempdir = $test->tempdir;
    $test->remove_tempdir;    # $tempdir no longer exists
    $tempdir = $test->tempdir;    # new temp directory

=head2 C<remove_tempdir>

    $test->remove_tempdir;

Removes current temp directory (if any) returned by C<< $test->tempdir >>.
