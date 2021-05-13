package Net::OpenAPI::Builder::Docs;

# ABSTRACT: Generates the Redoc documentation for your project

use Moo;
use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(unindent tidy_code);
use Net::OpenAPI::App::Types qw(
  NonEmptyStr
  PackageName
  OpenAPIPath
);
our $VERSION = '0.01';

=head1 PARAMETERS

=head2 schema_file

Filename for OpenAPI schema

=cut

has schema_file => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

=head2 base

The base package path for the docs.

=cut

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

=head2 path

The OpenAPI base for the docs

=cut

has path => (
    is       => 'ro',
    isa      => OpenAPIPath,
    required => 1,
);

=head2 package

Full package name for the docs package

=cut

has package => (
    is      => 'lazy',
    isa     => PackageName,
    builder => sub {
        my $self = shift;
        return join '::' => $self->base, 'App::Docs';
    },
);

=head1 OUTPUT ATTRIBUTES

=head2 code

All generated code for this Controller

=cut

has code => (
    is      => 'lazy',
    isa     => NonEmptyStr,
    builder => sub {
        my $self = shift;

        return template(
            name     => 'controller',
            template => $self->_docs_template,
            data     => {
                package => $self->package,
                base    => $self->base,
                path    => $self->path,
                docs    => [ $self->schema_file ],
            },
            tidy => 1,
        );
    }
);

sub _docs_template {
    state $template;

    return $template //= do {
        my $template_content = unindent(<<'        EOF');
        package [% package %];

        use strict;
        use warnings;
        use Plack::Response;
        use Net::OpenAPI::App::Response;
        use Net::OpenAPI::App::StatusCodes ':all';

        =head1 NAME

        [% package %] - Net::OpenAPI docs

        =cut

        [% rewrite_boundary %]
        sub index {
            my ( $class, $req ) = @_;
            if ( my $path_info = $req->path_info) {
                return $class->_get_docs($req);
            }
            else {
                return $class->_get_index($req);
            }
        }

        sub _get_docs {
            my ($class, $req) = @_;
            my $path_info = $req->path_info;
            my $docs = <<"END";
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
            <p><a href="/api/docs">[% base %] Documentation Home</a></p>
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
            <h1>[% base %] OpenAPI documentation</h1>
            <ul>
              [% FOREACH doc IN docs %]<li><a class="openapi" href="[% path %]/[% doc %]">[% doc %]</a></li>[% END %]
            </ul>
          </body>
        </html>
        END
            my $res = Plack::Response->new(200);
            $res->content_type('text/html');
            $res->body($index);
            return $res->finalize;
        }
        [% rewrite_boundary %]

        1;
        EOF

        $template_content;
    };
}

1;

__END__

Horribly incomplete and a nasty hack. The index() method needs to look for a
path and if the path after the doc base matches and openapi doc path, then
they should get this template:


That should render our OpenAPI documents, but I'm tired and not yet done.

We will also need https://metacpan.org/pod/Plack::Middleware::Static so that plack
can serve the actual openapi document
