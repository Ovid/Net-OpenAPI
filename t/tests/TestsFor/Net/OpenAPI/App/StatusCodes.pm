package TestsFor::Net::OpenAPI::App::StatusCodes;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::App::StatusCodes qw(:all);

sub test_basics {
    my $test = shift;

    is HTTPInternalServerError, 500, 'Our HTTP constants should just be the status codes';
    is status_message_for(500), 'Internal Server Error', '... and we should be able to get messages for them';

    ok is_error(HTTPNotImplemented),     'is_error() should return true for errors';
    ok !is_error(HTTPTemporaryRedirect), '... and false for non-errors';
}

1;
