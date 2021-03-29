package OpenAPi::Microservices::Utils::Core;

# ABSTRACT: Utilities for munging OpenAPI::Microservices data

use OpenAPI::Microservices::Policy;
use base 'Exporter';

our @EXPORT_OK = qw(
  resolve_method
  trim
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head1 FUNCTIONS

All functions are exportable on demand via:

    use OpenAPi::Microservices::Utils::Core 'trim';

Or all at once:

    use OpenAPi::Microservices::Utils::Core ':all';

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
    $base =~ s/::$//;    # optionally allow My::Project::
    my ( $root, @path ) = grep {/\S/} split m{/} => $path;
    $root = ucfirst $root;
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
        $method = "args_$method";
    }
    $method =~ s/_+$//;
    $method =~ s/-/_/g;
    return ( "${base}::$root", $method, \@args );
}

1;
