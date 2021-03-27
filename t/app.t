#!/usr/bin/env perl

use v5.16.0;
use lib qw(lib t/lib);

use Test::Class::Moose::Load 't/tests';
use Test::Class::Moose::Runner;
Test::Class::Moose::Runner->new->runtests;
