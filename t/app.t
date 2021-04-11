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
my $runner = Test::Class::Moose::Runner->new(%args);
$runner->runtests;
show_report( $runner->test_report, 5 );
show_failing_classes_and_methods( $runner->test_report );

sub path_to_class {
    my $path = shift;

    # if we don't end in a .pm, it's probably a class name
    return $path unless $path =~ s/\.pm$//;
    $path =~ s{.*(?=TestsFor)}{};
    $path =~ s/\.pm$//;
    $path =~ s{/}{::}g;
    return $path;
}

sub show_report {
    my ( $test_report, $num_slowest ) = @_;
    my ( @classes, @methods );

    my ( $num_classes, $num_instances, $num_methods, $num_tests ) = ( 0, 0, 0, 0 );

    for my $class ( $test_report->all_test_classes ) {
        $num_classes++;
        my $class_name = $class->name;
        push @classes => [ $class_name => $class->time ];

        foreach my $instance ( $class->all_test_instances ) {
            $num_instances++;
            for my $method ( $instance->all_test_methods ) {
                $num_methods++;
                $num_tests += $method->num_tests_run;
                my $method_name = $method->name;
                $method_name = $class_name . '::' . $method_name;
                push @methods => [ $method_name => $method->time ];
            }
        }
    }

    _report_slowest( "classes", $num_slowest, @classes );
    _report_slowest( "methods", $num_slowest, @methods );

    say STDERR <<"END_SUMMARY";

Summary:

Classes:   $num_classes
Instances: $num_instances
Methods:   $num_methods
Tests:     $num_tests
END_SUMMARY

    return;
} ## end sub show_report

sub _report_slowest {
    my ( $type, $num_slowest, @things ) = @_;
    @things = sort slowest_first @things;
    @things = @things[ 0 .. $num_slowest - 1 ] if @things > $num_slowest;

    say STDERR "Slowest $type";
    say STDERR "\t$_->[0]: " . $_->[1]->duration for @things;

    return;
}

sub slowest_first {
    no warnings 'numeric';    ## no critic (ProhibitNoWarnings)
    return $b->[1]->duration <=> $a->[1]->duration;
}

sub show_failing_classes_and_methods {
    my ($test_report)  = @_;
    my $failure_report = "\n";
    my $longest        = 0;
    my $failures_found;

    for my $class ( $test_report->all_test_classes ) {
        for my $instance ( $class->all_test_instances ) {
            next if $instance->passed;
            my $class_name = $instance->name;
            $failures_found = 1;

            my $class_printed;
            for my $method ( $instance->all_test_methods ) {
                next if $method->passed;
                my $method_name = $method->name;

                unless ( $class_printed++ ) {
                    my $message = "$class_name failed. Failing methods:\n";
                    $longest = length $message
                      if length $message > $longest;
                    $failure_report .= $message;
                }
                my $message = "    $method_name\n";
                $longest = length $message if length $message > $longest;
                $failure_report .= $message;
            }
            $failure_report .= "\n";
        } ## end for my $instance ($class...)
    } ## end for my $class ($test_report...)

    return if !$failures_found;

    my $builder = Test::Builder->new;
    $builder->diag("---------- Failure summary ----------");

    # make all lines the same length
    $failure_report =~ s/^(.*)$/$1.(' ' x ($longest - length($1))).'#'/gem;
    my $marker = '#' x ( 1 + $longest );
    $failure_report = "$marker\n$failure_report$marker";
    $builder->diag($failure_report);

    return;
}

=head1 NAME

t/app.t - Run xUnit tests

=head1 SYNOPSIS

    # run xUnit tests
    prove t/app.t

    # run xUnit tests in verbose mode
    prove -v t/app.t

    # run a single test class
    prove -v t/app.t :: TestsFor::Net::OpenAPI::Utils::ReWrite

    # run a single test class
    prove -v t/app.t :: t/tests/TestsFor/Net/OpenAPI/Utils/ReWrite.pm

    # run test methods matching regex "test_rewrite"
    prove -v t/app.t :: TestsFor::Net::OpenAPI::Utils::ReWrite --method test_rewrite
