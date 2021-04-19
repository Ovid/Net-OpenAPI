#!/usr/bin/env perl

#!/usr/bin/env perl

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: 9a1a6fa3e5cc31935426e1170098c7e0

use strict;
use warnings;
use Plack::Builder;
use lib 'lib';               # XXX fix me (load Net::OpenAPI::*)
use lib '../lib';            # XXX fix me (load Net::OpenAPI::*)
use lib 't/test_app/lib';    # XXX fix me (load Net::OpenAPI::*)

use My::Project::OpenAPI::App;

builder {
    enable "Plack::Middleware::Static", path => qr{^/openapi/.+\.(?:json|yaml)$}, root => '.';
    mount '/api/v1'   => builder { My::Project::OpenAPI::App->get_app };
    mount '/api/docs' => builder { My::Project::OpenAPI::App->doc_index };
};

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: 9a1a6fa3e5cc31935426e1170098c7e0