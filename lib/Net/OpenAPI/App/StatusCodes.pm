package Net::OpenAPI::App::StatusCodes;

# ABSTRACT: HTTP Status Code Information

use Net::OpenAPI::Policy;
use Exporter 'import';
our @EXPORT_OK = qw(
  status_message_for
  is_info
  is_success
  is_redirect
  is_error
  is_client_error
  is_server_error
  is_cacheable_by_default
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

my %MESSAGE_FOR = (

    #1×× Informational
    100 => 'Continue',
    101 => 'Switching Protocols',
    102 => 'Processing',

    #2×× Success
    200 => 'OK',
    201 => 'Created',
    202 => 'Accepted',
    203 => 'Non-authoritative Information',
    204 => 'No Content',
    205 => 'Reset Content',
    206 => 'Partial Content',
    207 => 'Multi-Status',
    208 => 'Already Reported',
    226 => 'IM Used',

    #3×× Redirection
    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other',
    304 => 'Not Modified',
    305 => 'Use Proxy',
    307 => 'Temporary Redirect',
    308 => 'Permanent Redirect',

    #4×× Client Error
    400 => 'Bad Request',
    401 => 'Unauthorized',
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',
    413 => 'Payload Too Large',
    414 => 'Request-URI Too Long',
    415 => 'Unsupported Media Type',
    416 => 'Requested Range Not Satisfiable',
    417 => 'Expectation Failed',
    418 => 'I\'m a teapot',
    421 => 'Misdirected Request',
    422 => 'Unprocessable Entity',
    423 => 'Locked',
    424 => 'Failed Dependency',
    426 => 'Upgrade Required',
    428 => 'Precondition Required',
    429 => 'Too Many Requests',
    431 => 'Request Header Fields Too Large',
    444 => 'Connection Closed Without Response',
    451 => 'Unavailable For Legal Reasons',
    499 => 'Client Closed Request',

    #5×× Server Error
    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    505 => 'HTTP Version Not Supported',
    506 => 'Variant Also Negotiates',
    507 => 'Insufficient Storage',
    508 => 'Loop Detected',
    510 => 'Not Extended',
    511 => 'Network Authentication Required',
    599 => 'Network Connect Timeout Error',
);

my %CODE_FOR_SHORT_NAME = map {s/\W//gr} reverse %MESSAGE_FOR;
delete $CODE_FOR_SHORT_NAME{Imateapot};
$CODE_FOR_SHORT_NAME{ImATeapot} = 418;

my $eval = '';
foreach my $short_name ( sort { $CODE_FOR_SHORT_NAME{$a} <=> $CODE_FOR_SHORT_NAME{$b} } keys %CODE_FOR_SHORT_NAME ) {
    my $code = $CODE_FOR_SHORT_NAME{$short_name};
    my $name = "HTTP$short_name";
    push @EXPORT_OK => $name;
    $eval .= "sub $name () { $code }\n";
    $eval .= "push(\@EXPORT_OK, '$name');\n";
}
eval $eval;
$EXPORT_TAGS{constants}  = [ grep {/^HTTP/} @EXPORT_OK ];
$EXPORT_TAGS{predicates} = [ grep {/^is_/} @EXPORT_OK ];
die $@ if $@;

=head2 FUNCTIONS

=head2 C<status_message_for>

    my $message = status_message_for(403);              # Forbidden
    my $message = status_message_for(HTTPForbidden);    # Forbidden

Returns the message corresponding to the status code.

=cut

sub status_message_for {
    return $MESSAGE_FOR{+shift};
}

# "liberated" from HTTP::Status
sub is_info ($)         { my $code = shift; $code && $code >= 100 && $code < 200; }
sub is_success ($)      { my $code = shift; $code && $code >= 200 && $code < 300; }
sub is_redirect ($)     { my $code = shift; $code && $code >= 300 && $code < 400; }
sub is_error ($)        { my $code = shift; $code && $code >= 400 && $code < 600; }
sub is_client_error ($) { my $code = shift; $code && $code >= 400 && $code < 500; }
sub is_server_error ($) { my $code = shift; $code && $code >= 500 && $code < 600; }

sub is_cacheable_by_default ($) {
    my $code = shift;
    $code && (
        $code == 200       # OK
        || $code == 203    # Non-Authoritative Information
        || $code == 204    # No Content
        || $code == 206    # Not Acceptable
        || $code == 300    # Multiple Choices
        || $code == 301    # Moved Permanently
        || $code == 308    # Permanent Redirect
        || $code == 404    # Not Found
        || $code == 405    # Method Not Allowed
        || $code == 410    # Gone
        || $code == 414    # Request-URI Too Large
        || $code == 451    # Unavailable For Legal Reasons
        || $code == 501    # Not Implemented
    );
}

1;

__END__

=head1 PREDICATE FUNCTIONS

The following predicate functions (true/false) are exportable individually or all at once:

    use Net::OpenAPI::App::StatusCodes qw(is_error is_cacheable_by_default);
    # or
    use Net::OpenAPI::App::StatusCodes qw(:predicates);

=over 4

=item * C<is_info($status_code)>

=item * C<is_success($status_code)>

=item * C<is_redirect($status_code)>

=item * C<is_error($status_code)>

=item * C<is_client_error($status_code)>

=item * C<is_server_error($status_code)>

=item * C<is_cacheable_by_default($status_code)>

=back

=head1 CONSTANTS

Constants may be exported individually or all all once:

    use Net::OpenAPI::App::StatusCodes qw(HTTPSwitchingProtocols HTTPResetContent);
    # or
    use Net::OpenAPI::App::StatusCodes qw(:constants);

=over 4

=item * C<HTTPContinue> (100)

=item * C<HTTPSwitchingProtocols> (101)

=item * C<HTTPProcessing> (102)

=item * C<HTTPOK> (200)

=item * C<HTTPCreated> (201)

=item * C<HTTPAccepted> (202)

=item * C<HTTPNonauthoritativeInformation> (203)

=item * C<HTTPNoContent> (204)

=item * C<HTTPResetContent> (205)

=item * C<HTTPPartialContent> (206)

=item * C<HTTPMultiStatus> (207)

=item * C<HTTPAlreadyReported> (208)

=item * C<HTTPIMUsed> (226)

=item * C<HTTPMultipleChoices> (300)

=item * C<HTTPMovedPermanently> (301)

=item * C<HTTPFound> (302)

=item * C<HTTPSeeOther> (303)

=item * C<HTTPNotModified> (304)

=item * C<HTTPUseProxy> (305)

=item * C<HTTPTemporaryRedirect> (307)

=item * C<HTTPPermanentRedirect> (308)

=item * C<HTTPBadRequest> (400)

=item * C<HTTPUnauthorized> (401)

=item * C<HTTPPaymentRequired> (402)

=item * C<HTTPForbidden> (403)

=item * C<HTTPNotFound> (404)

=item * C<HTTPMethodNotAllowed> (405)

=item * C<HTTPNotAcceptable> (406)

=item * C<HTTPProxyAuthenticationRequired> (407)

=item * C<HTTPRequestTimeout> (408)

=item * C<HTTPConflict> (409)

=item * C<HTTPGone> (410)

=item * C<HTTPLengthRequired> (411)

=item * C<HTTPPreconditionFailed> (412)

=item * C<HTTPPayloadTooLarge> (413)

=item * C<HTTPRequestURITooLong> (414)

=item * C<HTTPUnsupportedMediaType> (415)

=item * C<HTTPRequestedRangeNotSatisfiable> (416)

=item * C<HTTPExpectationFailed> (417)

=item * C<HTTPImATeapot> (418)

=item * C<HTTPMisdirectedRequest> (421)

=item * C<HTTPUnprocessableEntity> (422)

=item * C<HTTPLocked> (423)

=item * C<HTTPFailedDependency> (424)

=item * C<HTTPUpgradeRequired> (426)

=item * C<HTTPPreconditionRequired> (428)

=item * C<HTTPTooManyRequests> (429)

=item * C<HTTPRequestHeaderFieldsTooLarge> (431)

=item * C<HTTPConnectionClosedWithoutResponse> (444)

=item * C<HTTPUnavailableForLegalReasons> (451)

=item * C<HTTPClientClosedRequest> (499)

=item * C<HTTPInternalServerError> (500)

=item * C<HTTPNotImplemented> (501)

=item * C<HTTPBadGateway> (502)

=item * C<HTTPServiceUnavailable> (503)

=item * C<HTTPGatewayTimeout> (504)

=item * C<HTTPHTTPVersionNotSupported> (505)

=item * C<HTTPVariantAlsoNegotiates> (506)

=item * C<HTTPInsufficientStorage> (507)

=item * C<HTTPLoopDetected> (508)

=item * C<HTTPNotExtended> (510)

=item * C<HTTPNetworkAuthenticationRequired> (511)

=item * C<HTTPNetworkConnectTimeoutError> (599)

=back
