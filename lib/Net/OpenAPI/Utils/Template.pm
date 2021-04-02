package Net::OpenAPI::Utils::Template;

=head1 WARNING

Don't just C<perldoc Net::OpenAPI::Utils::Template>. This module contains
templates and those templates often contain POD. POD parsers get confused and
show some very messed up POD. Use the source, Luke.

=cut

# ABSTRACT: Code templates for Net::OpenAPI. Internal use only

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Template::Tiny;
use Net::OpenAPI::Utils::ReWrite;
use base 'Exporter';

our @EXPORT_OK = qw(
  template
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
       unless (@chunks == 3) {
           croak("Exactly two or zero rewrite boundaries allowed per template");
        }
        $chunks[1] = Net::OpenAPI::Utils::ReWrite->add_checksums($chunks[1]);
        $output = join '' => @chunks;
    }
    return $output;
}

sub _get_template {
    my $requested = shift;
    my %template = (
        app        => \&_app_template,
        controller => \&_controller_template,
        model      => \&_model_template,
        method     => \&_method_template,
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
use Net::OpenAPI::App::Exceptions qw(throw);
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
    throw( NotImplemented => "[% http_method %] [% path %]" );
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
    return <<"END";
package [% package %]

use v5.16.0;
use strict;
use warnings;

$REWRITE_BOUNDARY
[% FOREACH controller IN controllers %]use [% controller %];
[% END %]
[% FOR model IN models %]use [% model %];
[% END %]
sub routes {
    state \$routes = [];
    unless (\@\$routes) {
[% FOREACH controller IN controllers %]        push \@\$routes => [% controller %]->routes;
[% END %]    }
    return \$routes;
}
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
END
}

1;
