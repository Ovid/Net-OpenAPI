#!/usr/bin/env perl

use lib 'lib';
use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder;
use Getopt::Long;
GetOptions(
    'schema=s' => \( my $schema    = 'data/v3-petstore.json' ),
    'dir=s'    => \( my $directory = 'target' ),
    'base=s'   => \( my $base      = 'My::Project::OpenAPI' )
) or die "Bad Options";

my $builder = Net::OpenAPI::Builder->new(
    schema => $schema,
    base   => $base,
    dir    => $directory,
);
$builder->write;

__END__

=head1 NAME

write.pl - same openapi generator

=head1 SYNOPSIS

    perl -Ilib write.pl

Builds out an OpenAPI server app shell in the C<target/>, directory,
with a basename of 'My::Project::OpenAPI", using the C<data/v3-petstore.json>
schema. You can change any or all of those:

    perl -Ilib write.pl --dir /tmp
    perl -Ilib write.pl --base My::OpenAPI::Project
    perl -Ilib write.pl --schema my-schema.json

Currently it only understands V3 JSON schemas (easy to fix).

After it's done, assuming the schema was good, you can C<cd> into the target
directoryand run plackup C<script/app.psgi> and then:

    $ curl -v http://0:5000/pet/23

You will get an Unimplemented error. Edit C<lib/My/Project/OpenAPI/Model/Pet.pm>
to return the desired data structure and restart plack.

Currently we don't yet validate input or output (coming soon).

If you rerun C<write.pl>, it will I<not> overwrite the local changes you have made to
the endpoints.
