package OpenAPI::Microservices::Utils::Template;

use OpenAPI::Microservices::Policy;
use Template::Tiny;
use base 'Exporter';

our @EXPORT_OK = qw(
  template
);

sub template {
    my ( $path_to_template, $arg_for ) = @_;
    my $template = Template::Tiny->new;
    my $input    = _get_template($path_to_template);

    # Generate template results into a variable
    my $output = '';
    $template->process( \$input, $arg_for, \$output );
    return $output;
}

sub _get_template {
    my $requested = shift;
    state $template = {
        'controller' => 'package [% package %];

use strict;
use warnings;

[% code_for_routes %]

1;

__END__

=head1 NAME

[% package %] - OpenAPI::Microservices controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<OpenAPI::Microservices::App::Router> at compile time to determine which
model and method incoming requests are directed to.

The model handling this controller is L<[% model %]>.

=head1 ROUTES

[% FOREACH method IN methods %]
=head2 [% method.http_method %][% method.path %]

[% method.description %]

Requests handled by controller method L<[% method.name %]>
[% END %]
}
',
    };
    return $template->{$requested};
}

1;
