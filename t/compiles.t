#!/usr/bin/env perl

use v5.16.0;

use lib qw{lib t/lib t/tests};
use Test::Compile;

my $test = Test::Compile->new();
$test->all_files_ok(qw{lib t/lib t/tests});
$test->done_testing();
