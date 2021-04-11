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
  resolve_endpoint
  resolve_package
  resolve_root
  tidy_code
  trim
  unindent
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

=head2 C<resolve_endpoint>

    my ( $method, $args ) = resolve_method("get /store/order/{orderId}");

Like C<resolve_method>, but takes an endpoint name.

=cut

sub resolve_endpoint {
    my $endpoint = shift;
    my ( $http_method, $path ) = split /\s+/ => trim($endpoint), 2;
    $http_method = lc $http_method;
    return resolve_method( $http_method, $path );
}


=head2 C<resolve_method($http_method, $path)>

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

=head2 C<normalize_string($string)>

    $string = normalize_string($string);

Unidecodes the string and then strips all non-word characters.

=cut

sub normalize_string {
    my $string = shift;
    $string = unidecode($string);
    $string =~ s/\W//g;
    return $string;
}

=head2 C<unindent($string)>

	$string = unindent($string);

Unindent's string, using the length of leading spaces of the first line as the
amount to unindent by.

If any subsequent line has leading spaces less than the first line, this code will
C<croak()> with an appropriate error message.

Note that we assume spaces, not tabs.

=cut

sub unindent {
    my $str = shift;
    my $min = $str =~ /^(\s+)/ ? length($1) : 0;
    if ( $min > 0 ) {
        my $less_than = $min - 1;
        if ( $str =~ /^([ ]{0,$less_than}\b.*)$/m ) {
            croak("unindent() failed with line found with indentation less than '$min':\n[$1]");
        }
    }
    $str =~ s/^[ ]{0,$min}//gm if $min;
    return $str;
}
1;
