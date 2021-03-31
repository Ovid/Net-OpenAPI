package OpenAPI::Microservices::Utils::Core;

# ABSTRACT: Utilities for munging OpenAPI::Microservices data

# Be very careful about circular dependencies against this file
use OpenAPI::Microservices::Utils::Template::Tiny;
use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::App::Types qw(
    Bool
    Dict
    Directory
    NonEmptyStr
    Optional
    compile_named
);

use Perl::Tidy 'perltidy';
use Text::Unidecode 'unidecode';
use base 'Exporter';

our @EXPORT_OK = qw(
  get_path_prefix
  resolve_method
  tidy_code
  trim
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head1 FUNCTIONS

All functions are exportable on demand via:

    use OpenAPI::Microservices::Utils::Core 'trim';

Or all at once:

    use OpenAPI::Microservices::Utils::Core ':all';

=head2 C<trim($text)>

    my $trimmed = trim($text);

Trims leading and trailing whitespace from C<$text>.

=cut

sub trim {
    my $text = shift;
    $text =~ s/^\s+|\s+$//g;
    return $text;
}

=head2 C<resolve_method($package_base, $http_method, $path)>

    my ( $package, $method, $args ) = resolve_method(
        'My::Project::Model',
        'get',
        '/store/order/{orderId}'
    );

=cut

sub resolve_method {
    my ( $base, $http_method, $path ) = @_;
    $path = unidecode($path);
    $base =~ s/::$//;    # optionally allow My::Project::
    my ( $root, @path ) = grep {/\S/} split m{/} => $path;
    $root = ucfirst _normalize_string($root);
    my @args;
    my $method = $http_method;
    foreach my $element (@path) {
        if ( $element =~ /^{(?<arg>\w+)}$/ ) {
            push @args => $+{arg};
            $method .= '___';
        }
        elsif ( $method =~ /_$/ ) {
            $method .= $element;
        }
        else {
            $method .= "_$element";
        }
    }
    if (@args) {
        $method = "with_args_$method";
    }
    $method =~ s/_+$//;
    $method =~ s/-/_/g;
    return ( "${base}::$root", $method, \@args );
}

=head2 C<prefix>

    my $prefix = get_path_prefix($path);

Takes the first segment from a path, stripps all non-word characters,
upper-cases first letter, and returns it.

=cut

sub get_path_prefix {
    my $path = shift;
    my $prefix;
    if ( $path !~ m{^/(?<prefix>[^/]+)\b.*$} ) {
        croak("Cannot determine prefix from path: $path");
    }
    $prefix = $+{prefix};
    if ( $prefix =~ /^{/ ) {
        croak("Prefix must not be a path variable: $prefix");
    }
    return ucfirst _normalize_string($prefix);
}

=head2 C<tidy_code($code)>

    my $tidied = tidy_code($code);

Returns code run through L<Perl::Tidy>. See our F<.perltidrc> in this
distribution.

=cut

sub tidy_code {
    my $code = shift;

    my ( $stderr, $tidied );

    # need to clear @ARGV or else Perl::Tidy thinks you're trying
    # to provide a filename and dies
    local @ARGV;
    perltidy(
        source      => \$code,
        destination => \$tidied,
        stderr      => \$stderr,
    ) and die "Perl::Tidy error: $stderr";

    return $tidied;
}

sub _normalize_string {
    my $string = shift;
    $string = unidecode($string);
    $string =~ s/\W//g;
    return $string;
}

1;
