package OpenAPI::Microservices::Utils::Types;

# ABSTRACT: Keep our type tools orgnanized

use strict;
use warnings;
use Type::Library
  -base,
  -declare => qw(
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

my $IDENTIFIER = qr/(?:[A-Z_a-z][0-9A-Z_a-z]*)/;
declare PackageName, as Str,
  where { $_ =~ / ^ $IDENTIFIER (?::: $IDENTIFIER ) * $/x };

1;

__END__

=head1 SYNOPSIS

    package OpenAPI::Microservices;

    use OpenAPI::Microservices::Types qw(
      ArrayRef
      Dict
      Enum
      HashRef
      InstanceOf
      Str
      compile
    );

=head1 DESCRIPTION

This is an internal package for L<OpenAPI::Microservices>. It's probably overkill,
but if we want to be more strict later, this gives us the basics.

=head1 TYPE LIBRARIES

We automatically include the types from the following:

=over

=item * L<Types::Standard>

=item * L<Types::Common::Numeric>

=item * L<Types::Common::String>

=back

=head1 CUSTOME TYPES

=head2 C<PackageName>

Matches valid package names.

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
