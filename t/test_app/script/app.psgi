#!/usr/bin/env perl

#<<< do not touch any code between this and the end comment. Checksum: 1046dcc9678d2936310425c9f07d1dbb
use strict;
use warnings;
use Plack::Builder;
use lib 'lib';              # XXX fix me (load Net::OpenAPI::*)
use lib '../lib';           # XXX fix me (load Net::OpenAPI::*)
use lib 't/test_app/lib';    # XXX fix me (load Net::OpenAPI::*)

use My::Project::OpenAPI::App;

builder {
    enable "Plack::Middleware::Static", path => qr{^/openapi/.+\.(?:json|yaml)$}, root => '.';
    mount '/api/v1' => builder { My::Project::OpenAPI::App->get_app };
    mount '/api/docs' => builder { My::Project::OpenAPI::App->doc_index };
};
#>>> do not touch any code between this and the start comment. Checksum: 1046dcc9678d2936310425c9f07d1dbb
