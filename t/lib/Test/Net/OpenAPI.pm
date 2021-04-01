package Test::Net::OpenAPI;

# ABSTRACT: Base class for Net::OpenAPI xUnit tests

# vim: textwidth=200

use Test::Class::Moose;
use Net::OpenAPI::Policy;
with 'Test::Class::Moose::Role::AutoUse';

sub is_multiline_text {
    my ( $test, $text, $expected, $message ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my @text     = split /\n/ => $text;
    my @expected = split /\n/ => $expected;
    eq_or_diff \@text, \@expected, $message;
}

__PACKAGE__->meta->make_immutable;
