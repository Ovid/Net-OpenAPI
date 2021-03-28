#!/usr/bin/env perl

use v5.16.0;
use Getopt::Long;
GetOptions(
    \my %opt_for,
    'method=s',
) or die "Bad options";
use lib qw(lib t/lib);

use Test::Class::Moose::Load 't/tests';
use Test::Class::Moose::Runner;
my %args;

if (@ARGV) {
    $args{test_classes} => \@ARGV,;
}
if ( my $method = $opt_for{method} ) {
    $args{include} = qr/$method/,;
}
Test::Class::Moose::Runner->new(%args)->runtests;

__END__

=head1 NAME

t/app.t - Run xUnit tests

=head1 SYNOPSIS

    # run xUnit tests
    prove t/app.t

    # run xUnit tests in verbose mode
    prove -v t/app.t

    # run a single test class
    prove -v t/app.t :: TestsFor::OpenAPI::Microservices::Utils::ReWrite

    # run test methods matching regex "test_rewrite"
    prove -v t/app.t :: TestsFor::OpenAPI::Microservices::Utils::ReWrite --method test_rewrite
