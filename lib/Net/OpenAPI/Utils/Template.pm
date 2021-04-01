package Net::OpenAPI::Utils::Template;

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Template::Tiny;
use base 'Exporter';

our @EXPORT_OK = qw(
  template
);

sub template {
    my ( $template_name, $arg_for ) = @_;
    my $template = Net::OpenAPI::Utils::Template::Tiny->new( name => $template_name );
    my $input    = _get_template($template_name);

    # Generate template results into a variable
    my $output = '';
    $template->process( \$input, $arg_for, \$output );
    return $output;
}

sub _get_template {
    my $requested = shift;
    my %template = (
        controller => \&_controller_template,
        model      => \&_model_template,
        method     => \&_method_template,
    );
    my $code = $template{$requested} or croak("No such template for '$requested'");
    return $code->();
}

sub _controller_template {
    return <<'END';
package [% package %];

use strict;
use warnings;

[% code_for_routes %]

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

sub _model_template {
    return <<'END';
package [% name %];

use strict;
use warnings;
use Net::OpenAPI::Exceptions::HTTP::NotImplemented;
use Net::OpenAPI::App::Endpoint;
use namespace::autoclean;

[% reserved %]

=head1 NAME

[% name %]

=head1 METHODS
[% FOREACH method IN get_methods %]
[% method.to_string %]
[% END %]

1;
END
}

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
    Net::OpenAPI::Exceptions::HTTP::NotImplemented->throw("[% http_method %] [% path %]");
};
END
}

1;
