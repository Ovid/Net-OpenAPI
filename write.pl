#!/usr/bin/env perl

use lib 'lib';
use OpenAPI::Microservices::Policy;
use OpenAPi::Microservices::Builder;
use Mojo::Path;

my $path = Mojo::Path->new('/foo%2Fbar%3B/baz.html');
say $path->[0];

my $builder = OpenAPi::Microservices::Builder->new(
    schema => 'data/v3-petstore.json',
    to     => 'target',
);
