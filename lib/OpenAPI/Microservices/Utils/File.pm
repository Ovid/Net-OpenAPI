package OpenAPI::Microservices::Utils::File;

# ABSTRACT: Utilities for file handling

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Utils::ReWrite;
use OpenAPI::Microservices::App::Types qw(
    Bool
    Dict
    Directory
    NonEmptyStr
    Optional
    compile_named
);

use File::Path qw(make_path);
use File::Spec::Functions qw(catfile);
use base 'Exporter';

our @EXPORT_OK = qw(
  slurp
  splat
  write_file
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head2 C<write_file>

    write_file(
        path     => $path,
        file     => $filename,
        document => $data
        rewrite  => $boolean,
    );

Safely write C<$data> to C<$path/$filename>, creating the path if necessary. If
C<rewrite> is passed a true value, it assumes that if the file already exists, we
will use L<OpenAPI::Microservices::Utils::ReWrite> to rewrite the contents.

=cut

sub write_file {
    state $check = compile_named(
        path      => Directory,
        file      => NonEmptyStr,
        document  => NonEmptyStr,
        rewrite   => Optional [Bool],
        overwrite => Optional [Bool],
    );
    my $arg_for = $check->(@_);
    $arg_for->{overwrite} //= 1; # default
    make_path( $arg_for->{path} );
    my $file = catfile( $arg_for->{path}, $arg_for->{file} );
    if ( -e $file ) {
        return unless $arg_for->{overwrite};
        my $contents = slurp($file);
        my $rewrite = OpenAPI::Microservices::Utils::ReWrite->new(
            old_text   => $contents,
            new_text   => $arg_for->{document},
            identifier => $file,
        );
        $arg_for->{document} = $rewrite->rewritten;
    }
    splat( $file, $arg_for->{document} );
}

=head2 C<slurp($file)>

    my $contents = slurp($file);

Read entire contents of C<$file> and return them.

=cut

sub slurp {
    my $file = shift;

    open my $fh, '<', $file or croak qq{Can't open file "$file": $!};
    my $content = do { local $/; <$fh> };
    return $content;
}

=head2 C<splat( $file, data )>

    splat($file,$data);

Write C<$data> to C<$file>, overwriting previous contents.

=cut

sub splat {
    my ( $file, $content ) = ( shift, join '', @_ );
    open my $fh, '>', $file or croak qq{Can't open file "$file": $!};
    print {$fh} $content or croak qq{Can't write to file "$file": $!};
    return $file;
}

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

1;
