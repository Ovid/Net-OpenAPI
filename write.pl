#!/usr/bin/env perl

use lib 'lib';
use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder;

my $builder = OpenAPI::Microservices::Builder->new(
    schema => 'data/v3-petstore.json',
    base   => 'My::Project::OpenAPI::Model',
    dir    => 'target',
);
$builder->write;

my $packages = $builder->packages;
foreach my $package (values %$packages) {
    #    say $package->to_string;
}
