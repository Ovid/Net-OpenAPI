package Net::OpenAPI::App::Types;

# ABSTRACT: Keep our type tools orgnanized

use strict;
use warnings;
use Type::Library
  -base,
  -declare => qw(
  Directory
  HTTPMethod
  MethodName
  OpenAPIPath
  PackageName
  );

use Type::Utils -all;

# this gets us compile and compile_named
use Type::Params;

our $VERSION = '0.07';

our @EXPORT_OK;

BEGIN {
    extends qw(
      Types::Standard
      Types::Common::Numeric
      Types::Common::String
    );
    push @EXPORT_OK => (
        'compile',          # from Type::Params
        'compile_named',    # from Type::Params
    );
}

my $DIR = qr/[-a-zA-Z0-9_]+/;
declare Directory, as Str,
  where { m<^ (?: \./? )? $DIR (?:/$DIR)* >x };

my $IDENTIFIER = qr/(?:[A-Z_a-z][0-9A-Z_a-z]*)/;

declare MethodName, as Str,
  where { / ^ _* $IDENTIFIER $/x };

declare PackageName, as Str,
  where { / ^ $IDENTIFIER (?::: $IDENTIFIER ) * $/x };

declare OpenAPIPath, as Str,
  where { m< / \w+ (?: / (?: \w+ | \{ \w+ \} ) )* /? >x };

# there are more, but these should be the only ones OpenAPI worries about?
declare HTTPMethod, as Enum [qw/get put post delete patch/];

1;

__END__

=head1 SYNOPSIS

    package Net::OpenAPI;

    use Net::OpenAPI::Types qw(
      ArrayRef
      Dict
      Enum
      HashRef
      InstanceOf
      Str
      compile
    );

=head1 DESCRIPTION

This is an internal package for L<Net::OpenAPI>. It's probably overkill,
but if we want to be more strict later, this gives us the basics.

=head1 TYPE LIBRARIES

We automatically include the types from the following:

=over

=item * L<Types::Standard>

=item * L<Types::Common::Numeric>

=item * L<Types::Common::String>

=back

=head1 CUSTOM TYPES

=head2 C<PackageName>

Matches valid package names.

=head2 C<MethodName>

Matches valid method names.

=head2 C<HTTPMethod>

Valid HTTP methods for OpenAPI.

=head2 C<Directory>

Valid directory name. Generally must be C<\w+> separated by C</>. A single leading dot is permitted.

=head2 C<OpenAPIPath>

Matches a valid path from OpenAPI.

Rules:

=over 4

=item * That the first path segment must I<not> be a variable

=item * The path must begin with a C</>

=item * A trailing C</> is optional

=back

Examples:

    /get/{petId}       # good
    /get/{petId}/      # good
    /get/{petId}/all/  # good
    /get/{petId}/{all} # good
    /get/petId         # good

     get/{petId}       # bad
    /{get}/petId       # bad

=head1 EXTRAS

The following extra functions are exported on demand or if use the C<:all> export tag.

=over

=item * C<compile>

See L<Type::Params>

=item * C<compile_named>

See L<Type::Params>

=item * C<slurpy>

See L<Types::Standard>

=back
