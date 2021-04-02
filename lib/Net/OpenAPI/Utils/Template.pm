package Net::OpenAPI::Utils::Template;

# ABSTRACT: Code templates for Net::OpenAPI. Internal use only

=head1 WARNING

Don't just C<perldoc Net::OpenAPI::Utils::Template>. This module contains
templates and those templates often contain POD. POD parsers get confused and
show some very messed up POD. Use the source, Luke.

=cut

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Template::Tiny;
use Net::OpenAPI::Utils::ReWrite;
use Net::OpenAPI::App::Types qw(
  compile_named
  NonEmptyStr
  HashRef
  Directory
  Bool
);
use Net::OpenAPI::Utils::Core qw(
  tidy_code
);
use Net::OpenAPI::Utils::File qw(write_file);
use base 'Exporter';

our @EXPORT_OK = qw(
  template
  write_template
);
use Const::Fast;
const my $REWRITE_BOUNDARY => '###« REWRITE BOUNDARY »###';

sub template {
    my ( $template_name, $arg_for ) = @_;
    my $template = Net::OpenAPI::Utils::Template::Tiny->new( name => $template_name );
    my $input    = _get_template($template_name);

    # Generate template results into a variable
    my $output = '';
    $template->process( \$input, $arg_for, \$output );
    my @chunks = split /$REWRITE_BOUNDARY/ => $output;
    if ( @chunks > 1 ) {
        unless ( @chunks == 3 ) {
            croak("Exactly two or zero rewrite boundaries allowed per template");
        }
        $chunks[1] = Net::OpenAPI::Utils::ReWrite->add_checksums( $chunks[1] );
        $output = join '' => @chunks;
    }
    return $output;
}

sub write_template {
    state $check = compile_named(
        template_name => NonEmptyStr,
        template_data => HashRef,
        path          => Directory,
        file          => NonEmptyStr,
        tidy          => Bool,
    );
    my $arg_for = $check->(@_);
    my $result  = template(
        $arg_for->{template_name},
        $arg_for->{template_data},
    );
    if ( $arg_for->{tidy} ) {
        tidy_code($result);
    }
    write_file(
        path     => $arg_for->{path},
        file     => $arg_for->{file},
        document => $result,
    );
}

sub _get_template {
    my $requested = shift;
    my %template  = (
        app        => \&_app_template,
        controller => \&_controller_template,
        model      => \&_model_template,
        method     => \&_method_template,
        psgi       => \&_psgi_template,
        example    => \&_example_template,
    );
    my $code = $template{$requested} or croak("No such template for '$requested'");
    return $code->();
}

=head1 SYNOPSIS

    use Net::OpenAPI::Utils::Template qw(template);
    print template(
        'app',
        {
            package     => 'My::Package',
            models      => [ 'My::App::OpenAPI::Model', 'My::App::OpenAPI::Model2' ],
            controllers => [ 'My::App::OpenAPI::Controller', 'My::App::OpenAPI::Controller2' ],
            base        => 'My::App::OpenAPI',
        }
    );

=head1 DESCRIPTION

We use these templates to autogenerate our code. You must pass in the data required.
See L<Net::OpenAPI::Utils::Template::Tiny> to understand template behavior.

=head1 TEMPLATES

The following templates are provided.

=head2 C<example>

    my $output = template(
        'example',
        {
            foo => 'oof',
            bar => 'rab',
            baz => 'zab',
        }
    );

Requires three variables, all of which should be strings. C<foo>, C<bar>, C<baz>.

=cut

sub _example_template {

    # this is used for tests
    return <<"END";
Foo: [% foo %]

$REWRITE_BOUNDARY

Bar: [% bar %]

$REWRITE_BOUNDARY

Baz: [% baz %]
END
}

=head2 C<controller>

    my $controller_code = template(
        'controller',
        {
            code_for_routes => tidy_code($code),
            methods         => \@methods,
            package         => $controller,
            model           => $model,
        }
    );

=cut

sub _controller_template {
    return <<"END";
package [% package %];

use strict;
use warnings;

$REWRITE_BOUNDARY
[% code_for_routes %]
$REWRITE_BOUNDARY

1;

__END__

=head1 NAME

[% package %] - Net::OpenAPI controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

The model handling this controller is L<[% model %]>.

=head1 ROUTES

[% FOREACH method IN methods %]
=head2 [% method.http_method %][% method.path %]

[% method.description %]

Requests handled by controller method L<[% method.name %]>
[% END %]
END
}

=head2 C<model>

    my $model_code = template(
        'model',
        {
            name        => $model_name,
            get_endpoints => $self->get_endpoints,
            reserved    => tidy_code($code),
        }
    );

=cut

sub _model_template {
    return <<"END";
package [% name %];

use strict;
use warnings;
use Net::OpenAPI::App::Endpoint;
use [% response_class %];
use Net::OpenAPI::App::StatusCodes qw(HTTPNotImplemented);
use namespace::autoclean;

$REWRITE_BOUNDARY
[% reserved %]
$REWRITE_BOUNDARY

=head1 NAME

[% name %]

=head1 METHODS
[% FOREACH method IN get_endpoints %]
[% method.to_string %]
[% END %]

1;
END
}

=head2 C<_method_template>

    return template(
        'method',
        {
            request_params  => $method->request_params,
            response_params => $method->response_params,
            path            => $method->path,
            http_method     => $method->http_method,
            description     => $method->description,
        }
    );

=cut

sub _method_template {
    return <<'END';
=head2 C<[% http_method %] [% path %]>

[% description %]

=head2 Request Parameters

[% request_params %]

=head2 Response Parameters

[% response_params %]

=cut

endpoint '[% http_method %] [% path %]' => sub {
    my ($request, $params) = @_;
    return [% response_class %]->new(
       status_code => HTTPNotImplemented,
       body        => { info => '[% http_method %] [% path %]' },
    );
};
END
}

=head2 C<app>

    print template(
        'app',
        {
            package     => 'My::Package',
            models      => [ 'My::Model', 'My::Model2' ],
            controllers => [ 'My::Controller', 'My::Controller2' ],
            base        => 'My App Name',
        }
    );

=cut

sub _app_template {
    my $before = <<"END";
package [% package %];

$REWRITE_BOUNDARY
END

    my $do_not_touch = <<'END';
use v5.16.0;
use strict;
use warnings;
use Scalar::Util 'blessed';
use Mojo::JSON qw(encode_json);
use Plack::Request;
use Net::OpenAPI::App::Router;

[% FOREACH controller IN controllers %]use [% controller %];
[% END %]
[% FOR model IN models %]use [% model %];
[% END %]
my $router = Net::OpenAPI::App::Router->new;
$router->add_routes(_routes());

sub _routes {
    state $routes = [];
    unless (@$routes) {
[% FOREACH controller IN controllers %]        push @$routes => [% controller %]->routes;
[% END %]    }
    return $routes;
}

sub get_app {
    return sub {
        my $req   = Plack::Request->new(shift);
        my $match = $router->match($req)
          or return $req->new_response(404)->finalize;

        my $dispatcher = $match->{dispatch};
        my $res        = $req->new_response(200);
        $res->content_type('application/json');
        my $result;
        if ( eval { $result = $dispatcher->( $req, $match->{uri_params} ); 1 } ) {
            if ( blessed $result && $result->isa('Net::OpenAPI::App::Response') ) {
                $res = $req->new_response( $result->status_code );
                if ( my $body = $result->body ) {
                    $res->content_type('application/json');
                    $res->body( encode_json($body) );
                }
            }
            else {
                $res = $req->new_response(500);
            }
            $res->finalize;
        }
    };
}
END

    my $after = <<"END";
$REWRITE_BOUNDARY

1;

__END__

=head1 NAME

[% package %] - Application module for [% base %]

=head1 SYNOPSIS

    use [% package %];
    use Net::OpenAPI::App::Router;

    my \$router = Net::OpenAPI::App::Router->new;
    \$router->add_routes([% package %]->routes)

=head1 METHODS

=head2 C<routes>

    my \$routes = [% package %]->routes;

Class method. Returns an array reference of routes you can pass to
C<&Net::OpenAPI::App::Router::add_routes>.
END
    return join "\n" => $before, $do_not_touch, $after;
}

sub _psgi_template {
    return <<'END';
#!/usr/bin/env perl

use strict;
use warnings;
use lib '../lib'; # XXX fix me (load Net::OpenAPI::*)

use [% app %];
[% app %]->get_app;
END
}

1;
