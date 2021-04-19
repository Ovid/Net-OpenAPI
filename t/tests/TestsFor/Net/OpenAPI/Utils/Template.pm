package TestsFor::Net::OpenAPI::Utils::Template;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Utils::Template qw(template);

my $example_template = <<'EOF';
Foo: [% foo %]

[% rewrite_boundary %]

Bar: [% bar %]

[% rewrite_boundary %]

Baz: [% baz %]
EOF

sub test_template {
    my $test   = shift;
    my $output = template(
        name     => 'example',
        template => $example_template,
        data     => {
            foo => 'oof',
            bar => 'rab',
            baz => 'zab',
        }
    );
    my $expected = <<'END';
Foo: oof

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: 46da8ccba0874e95c56493dc07144692

Bar: rab

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: 46da8ccba0874e95c56493dc07144692


Baz: zab
END
    $test->is_multiline_text( $output, $expected, 'We should be able to generate a nice rewritable template' );
    explain $output;
}

sub test_errors {
    my $test = shift;
    my %args = (
        foo => 'oof',
        bar => 'rab',
        baz => undef,
    );
    throws_ok { template( name => 'example', template => $example_template, data => \%args ) }
    qr/Undefined value in template path 'baz' in 'example' template./,
      'Processing a template with undef or missing fields should generate an error';
}

1;
