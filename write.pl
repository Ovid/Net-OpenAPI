#!/usr/bin/env perl

use lib 'lib';
use OpenAPI::Microservices::Policy;
use OpenAPi::Microservices::Builder;

my $builder = OpenAPi::Microservices::Builder->new(
    schema => 'data/v3-petstore.json',
    base   => 'My::Project::OpenAPI::Model',
    to     => 'target',
);
$builder->write;
