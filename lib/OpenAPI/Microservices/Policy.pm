package OpenAPI::Microservices::Policy;

# ABSTRACT: Avoid boilerplate in our code

use 5.16.0;
use strict;
use warnings;
use feature ();
use utf8::all;
use autodie ();
use Carp;
use Try::Tiny;
use namespace::autoclean;

use Import::Into;

sub import {
    my ( $class, %rule_for ) = @_;

    $rule_for{except} ||= [];
    $rule_for{except} = [ $rule_for{except} ]
      unless 'ARRAY' eq ref $rule_for{except};

    my %skip   = map { $_ => 1 } $rule_for{except}->@*;
    my $caller = $rule_for{apply_to} // caller;

    # this one is mandatory
    feature->import::into( $caller, qw/:5.16/ );

    warnings->import::into($caller);

    strict->import::into($caller);
    utf8::all->import::into($caller) unless $skip{'utf8::all'};
    Try::Tiny->import::into( $caller, qw(try catch finally) )
      unless $skip{'Try::Tiny'};
    Carp->import::into( $caller, qw(carp croak) ) unless $skip{'Carp'};
    autodie->import::into( $caller, ':all' )      unless $skip{'autodie'};
    namespace::autoclean->import::into($caller)
      unless $skip{'namespace::autoclean'};
} ## end sub import

sub unimport {
    my $caller = caller;
    warnings->unimport::out_of($caller);
    strict->unimport::out_of($caller);
    utf8::all->unimport::out_of($caller);
    Try::Tiny->unimport::out_of($caller);
    autodie->unimport::out_of($caller);
    Carp->unimport::out_of($caller);
    namespace::autoclean->unimport::out_of($caller);
}

1;

__END__

=head1 SYNOPSIS

    use OpenAPI::Microservices::Policy;

=head1 DESCRIPTION

This module is a replacement for the following:

    use strict;
    use warnings;
    use v5.16;
    use utf8::all;
    use Carp qw(carp croak);
    use autodie ':all';
    use Try::Tiny;
    use namespace::autoclean;

=head1 Subverting Policy

Of course you would never, ever, dream of skipping any of the above classes.
Ignoring policy is not to be tolerated. But if you do (just this once), you
may pass a list of behaviors to exclude, via the C<except> tag.

    # utf8::all and Carp functionality will not apply to this code
    use OpenAPI::Microservices::Policy except => [qw/utf8::all Carp/];

    # excluding a single policy doesn't require an array reference
    use OpenAPI::Microservices::Policy except => 'namespace::autoclean';

The following may be excluded:

=over 4

=item * C<utf8::all>

=item * C<Try::Tiny>

=item * C<Carp>

=item * C<autodie>

=item * C<namespace::autoclean>

=back
