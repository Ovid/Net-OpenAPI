#!/usr/bin/env perl

use v5.16.0;
use Getopt::Long;
use lib qw(lib t/lib t/tests);

use Test::Class::Moose::Load 't/tests';
use Test::Class::Moose::Runner;
use Test2::Plugin::UTF8;

GetOptions(
    \my %opt_for,
    'method=s',
) or die "Bad options";

my %args;

if (@ARGV) {
    $args{test_classes} = [
        map    { path_to_class($_) }    # if they give us paths, use class names
          grep { $_ ne '::' }           # but don't include the '::' if they run this with Perl instead of prove
          @ARGV                         # and take this from command line args
    ];
}
if ( my $method = $opt_for{method} ) {
    $args{include} = qr/$method/;
}
Test::Class::Moose::Runner->new(%args)->runtests;

sub path_to_class {
    my $path = shift;

    # if we don't end in a .pm, it's probably a class name
    return $path unless $path =~ s/\.pm$//;
    $path =~ s{.*(?=TestsFor)}{};
    $path =~ s/\.pm$//;
    $path =~ s{/}{::}g;
    return $path;
}

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

    # run a single test class
    prove -v t/app.t :: t/tests/TestsFor/OpenAPI/Microservices/Utils/ReWrite.pm

    # run test methods matching regex "test_rewrite"
    prove -v t/app.t :: TestsFor::OpenAPI::Microservices::Utils::ReWrite --method test_rewrite
