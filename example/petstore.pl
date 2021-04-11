#!/usr/bin/env perl

use lib 'lib';
use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder;
use Getopt::Long;
GetOptions(
    'schema=s'   => \( my $schema    = 'data/v3-petstore.json' ),
    'base=s'     => \( my $base      = 'My::Project::OpenAPI' ),
    'dir=s'      => \( my $directory = 'target' ),
    'api_base=s' => \( my $api_base  = '/api/v1' ),
    'doc_base=s' => \( my $doc_base  = '/api/docs' ),
) or die "Bad Options";

my $builder = Net::OpenAPI::Builder->new(
    schema_file => $schema,
    base        => $base,
    dir         => $directory,
    api_base    => $api_base,
    doc_base    => $doc_base,
);
$builder->write;

__END__

=head1 NAME

petstore.pl - Sample openapi server generator based on canonical OpenAPI Petstore

=head1 SYNOPSIS

    perl -Ilib petstore.pl

Builds out an OpenAPI server app shell in the C<target/>, directory,
with a basename of 'My::Project::OpenAPI", using the C<data/v3-petstore.json>
schema. You can change any or all of those:

    perl -Ilib petstore.pl --dir /tmp
    perl -Ilib petstore.pl --base My::OpenAPI::Project
    perl -Ilib petstore.pl --schema my-schema.json
    perl -Ilib petstore.pl --api_base /path/to/my/api
    perl -Ilib petstore.pl --doc_base /path/to/my/api/docs

Currently it only understands V3 JSON schemas (easy to fix?).

After it's done, assuming the schema was good, you can C<cd> into the target
directoryand run plackup C<script/app.psgi> and then:

    $ curl -v http://0:5000/api/v1/pet/23

You will get an Unimplemented error. Edit
C<lib/My/Project/OpenAPI/Controller/Pet.pm> to return the desired data
structure and restart plack.

Currently we don't yet validate input or output (coming soon).

If you rerun C<petstore.pl>, it will I<not> overwrite the local changes you have made to
the endpoints.
