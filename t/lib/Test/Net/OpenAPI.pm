package Test::Net::OpenAPI;

# ABSTRACT: Base class for Net::OpenAPI xUnit tests

# vim: textwidth=200

use Test::Class::Moose;
use Net::OpenAPI::Policy;
with 'Test::Class::Moose::Role::AutoUse';

=head2 C<is_multiline_text>

    $test->is_multiline_text($have, $want, $message);

Test which passes if C<$have> and C<$want> are the same. however, we split
the texts on newlines and use C<eq_or_diff> to make it easier to spot where
the differences are.

=cut

sub is_multiline_text {
    my ( $test, $text, $expected, $message ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my @text     = split /\n/ => $text;
    my @expected = split /\n/ => $expected;
    eq_or_diff \@text, \@expected, $message;
}

__PACKAGE__->meta->make_immutable;
