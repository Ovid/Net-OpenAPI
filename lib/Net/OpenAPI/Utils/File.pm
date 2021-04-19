package Net::OpenAPI::Utils::File;

# ABSTRACT: Utilities for file handling

use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  Bool
  Dict
  Directory
  NonEmptyStr
  Optional
  compile_named
);

use File::Path qw(make_path);
use File::Spec::Functions qw(catfile);
use CodeGen::Protection qw(rewrite_code);
use base 'Exporter';

our @EXPORT_OK = qw(
  slurp
  splat
  unindent
  write_file
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head1 FUNCTIONS

All functions are exportable on demand via:

    use Net::OpenAPI::Utils::File 'slurp';

Or all at once:

    use Net::OpenAPI::Utils::File ':all';

=head2 C<write_file>

    write_file(
        path     => $path,
        file     => $filename,
        document => $data
        rewrite  => $boolean,
    );

Safely write C<$data> to C<$path/$filename>, creating the path if necessary.
If C<rewrite> is passed a true value, it assumes that if the file already
exists, we will use
L<CodeGen::Protection|https://metacpan.org/pod/CodeGen::Protection> to rewrite
the contents.

=cut

sub write_file {
    state $check = compile_named(
        path      => Directory,
        file      => NonEmptyStr,
        document  => NonEmptyStr,
        overwrite => Optional [Bool],
    );
    my $arg_for = $check->(@_);
    make_path( $arg_for->{path} );
    my $file = catfile( $arg_for->{path}, $arg_for->{file} );
    if ( -e $file && !$arg_for->{overwrite} ) {
        my $contents = slurp($file);
        my $rewrite = rewrite_code(
            type           => 'Perl',
            existing_code  => $contents,
            protected_code => $arg_for->{document},
            name           => $file,
            tidy           => 1,
        );
        $arg_for->{document} = $rewrite;
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

1;
