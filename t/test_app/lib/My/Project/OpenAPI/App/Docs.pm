package My::Project::OpenAPI::App::Docs;

use strict;
use warnings;
use Plack::Response;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::App::Docs - Net::OpenAPI docs

=cut

#<<< do not touch any code between this and the end comment. Checksum: a0bdade3863a3e593e55730218aa6997
package My::Project::OpenAPI::App::Docs;

use strict;
use warnings;
use Plack::Response;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::App::Docs - Net::OpenAPI docs

=cut

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: 33f71afe129b04a564961ca154a6122a

sub index {
    my ( $class, $req ) = @_;
    if ( my $path_info = $req->path_info ) {
        return $class->_get_docs($req);
    }
    else {
        return $class->_get_index($req);
    }
}

sub _get_docs {
    my ( $class, $req ) = @_;
    my $path_info = $req->path_info;
    my $docs      = <<"END";
<!DOCTYPE html>
<html>
<head>
    <title>ReDoc</title>
    <!-- needed for adaptive design -->
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">
    <!-- Redoc styles do not apply to our own styles, so we need to apply them manually -->
    <style>
    body { font-family: "Montserrat", "Roboto", sans-serif }
    </style>
</head>
<body>
    <p><a href="/api/docs">My::Project::OpenAPI Documentation Home</a></p>
    <redoc spec-url='/openapi/$path_info'></redoc>
    <script src="https://cdn.jsdelivr.net/npm/redoc\@next/bundles/redoc.standalone.js"> </script>
</body>
</html>
END
    my $res = Plack::Response->new(200);
    $res->content_type('text/html');
    $res->body($docs);
    return $res->finalize;
}

sub _get_index {

    # bless me father for I have sinned
    my $index = <<'END';
<!DOCTYPE html>
<html>
  <head>
    <title>Docs</title>
    <!-- needed for adaptive design -->
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">
    <!-- Redoc styles do not apply to our own styles, so we need to apply them manually -->
    <style>
      body { font-family: "Montserrat", "Roboto", sans-serif }
    </style>
  </head>
  <body>
    <h1>My::Project::OpenAPI OpenAPI documentation</h1>
    <ul>
      <li><a class="openapi" href="/api/docs/data/v3-petstore.json">data/v3-petstore.json</a></li>
    </ul>
  </body>
</html>
END
    my $res = Plack::Response->new(200);
    $res->content_type('text/html');
    $res->body($index);
    return $res->finalize;
}

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: 33f71afe129b04a564961ca154a6122a


1;
#>>> do not touch any code between this and the start comment. Checksum: a0bdade3863a3e593e55730218aa6997


1;