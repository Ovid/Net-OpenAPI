package Net::OpenAPI::Utils::Core;

# ABSTRACT: Utilities for munging Net::OpenAPI data

# Be very careful about circular dependencies against this file
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
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
  get_path_and_filename
  get_path_prefix
  normalize_string
  resolve_method
  resolve_package
  resolve_root
  tidy_code
  trim
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head2 C<get_path_and_filename($dir, $package_name)>

    my ($full_path, $filename) = get_path_and_filename($target_dir, $package_name);

Gets the full path and filename of a package, given the target directory it
will be written to. Usually used with C<write_file> of
L<Net::OpenAPI::Utils::File>.

=cut

sub get_path_and_filename {
    my ( $dir, $package_name ) = @_;

    my ( $base, $filename );
    if ( $package_name =~ /^(?<path>.*::)(?<file>.*)$/ ) {
        $base     = $+{path};
        $filename = $+{file};
        $base =~ s{::}{/}g;
    }
    else {
        croak("Bad package name: $package_name");
    }

    $filename .= ".pm";
    my $path = "$dir/lib/$base";
    return ( $path, $filename );
}

=head1 FUNCTIONS

All functions are exportable on demand via:

    use Net::OpenAPI::Utils::Core 'trim';

Or all at once:

    use Net::OpenAPI::Utils::Core ':all';

=head2 C<trim($text)>

    my $trimmed = trim($text);

Trims leading and trailing whitespace from C<$text>.

=cut

sub trim {
    my $text = shift;
    $text =~ s/^\s+|\s+$//g;
    return $text;
}

=head2 C<resolve_package>

    my $package = resolve_package(
        'My::OpenAPI::Project',  # project base name
        'Model',                 # Model or Controller
        '/pet/{petId}'           # OpenAPI path
    );

=cut

sub resolve_package {
    my ( $base, $type, $path ) = @_;
    $base =~ s/::$//;    # optionally allow My::Project::
    my $root = resolve_root($path);
    return "${base}::${type}::$root";
}

=head2 C<resolve_root>

    my $root = resolve_root($OpenAPIPath);

Returns the first segment name, unidecoded, with an uppercase first letter and
all non-word characters removed. Frequently used to create package names.

=cut

sub resolve_root {
    my $path = shift;
    my ( $root, undef ) = grep {/\S/} split m{/} => $path;
    return ucfirst normalize_string($root);
}

=head2 C<resolve_method($package_base, $http_method, $path)>

    my ( $method, $args ) = resolve_method(
        'get',  # or GET (http method)
        '/store/order/{orderId}'
    );

=cut

sub resolve_method {
    my ( $http_method, $path ) = @_;
    my ( undef, @path ) = grep {/\S/} split m{/} => $path;
    my @args;
    my $method = lc $http_method;
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
    return ( $method, \@args );
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
    return ucfirst normalize_string($prefix);
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

sub normalize_string {
    my $string = shift;
    $string = unidecode($string);
    $string =~ s/\W//g;
    return $string;
}

1;
