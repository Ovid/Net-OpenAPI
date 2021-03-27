#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';
use OpenAPi::Microservices::Builder;
my $builder = OpenAPi::Microservices::Builder->new(
    schema => 'data/petstore.yaml'
);
$builder->write;
