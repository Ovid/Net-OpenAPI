#!/usr/bin/env perl

use Net::OpenAPI::Policy;
my $base = 'Net::OpenAPI::Exceptions::HTTP::';
my $base_path = 'Net/OpenAPI/Exceptions/HTTP/';

while ( my $status = <DATA> ) {
    chomp($status);
    my ( $code, $message ) = split ' ' => $status, 2;
    my $postfix = $message;
    $postfix =~ s/ //g;
    $postfix =~ s/\W//g;

    my $package      = "$base$postfix";
    my $test_package = "TestsFor::$base$postfix";
    my $path         = "lib/$base_path$postfix.pm";
    my $test_path    = "t/tests/TestsFor/$base_path$postfix.pm";

    open my $fh, '>', $path;
    say {$fh} code($package, $code, $message);
    open my $test_fh, '>', $test_path;
    say {$test_fh} test($test_package, $code, $message);
}

sub test {
    my ($package, $code, $message) = @_;
    return <<"END";
package $package;

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Moose;
with 'Test::Net::OpenAPI::Exceptions::Role::HTTP';

sub status_code {$code}
sub message     {'$message'}

1;
END
}

sub code {
    my ( $package, $code, $message ) = @_;
    return <<"END";
package $package;

# ABSTRACT: Exception class for the HTTP '$code $message' error

use Moo;
with 'Net::OpenAPI::Exceptions::Role::HTTP';
use overload '""' => 'to_string', fallback => 1;

=head1 IMPLEMENTS

This class implements the 'Net::OpenAPI::Exceptions::Role::HTTP' role.

=head1 METHODS

=head2 C<status_code>

    my \$code = \$self->status_code;

Returns $code.

=cut

sub status_code { $code }

=head2 C<message>

    my \$message = \$self->message;

Returns '$message'.

=cut

sub message { '$message' }

1;
END
}


__DATA__
300 Multiple Choices
301 Moved Permanently
302 Found
303 See Other
304 Not Modified
305 Use Proxy
307 Temporary Redirect
308 Permanent Redirect
400 Bad Request
401 Unauthorized
402 Payment Required
403 Forbidden
404 Not Found
405 Method Not Allowed
406 Not Acceptable
407 Proxy Authentication Required
408 Request Timeout
409 Conflict
410 Gone
411 Length Required
412 Precondition Failed
413 Payload Too Large
414 Request-URI Too Long
415 Unsupported Media Type
416 Requested Range Not Satisfiable
417 Expectation Failed
421 Misdirected Request
422 Unprocessable Entity
423 Locked
424 Failed Dependency
426 Upgrade Required
428 Precondition Required
429 Too Many Requests
431 Request Header Fields Too Large
444 Connection Closed Without Response
451 Unavailable For Legal Reasons
499 Client Closed Request
500 Internal Server Error
501 Not Implemented
502 Bad Gateway
503 Service Unavailable
504 Gateway Timeout
505 HTTP Version Not Supported
506 Variant Also Negotiates
507 Insufficient Storage
508 Loop Detected
510 Not Extended
511 Network Authentication Required
599 Network Connect Timeout Error
