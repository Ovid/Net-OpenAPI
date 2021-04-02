package TestsFor::Net::OpenAPI::Utils::Template;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Utils::Template qw(template);

sub test_template {
    my $test   = shift;
    my $output = template(
        'example',
        {
            foo => 'oof',
            bar => 'rab',
            baz => 'zab',
        }
    );
    my $expected = <<'END';
Foo: oof

#<<<: do not touch any code between this and the end comment. Checksum: 46da8ccba0874e95c56493dc07144692
Bar: rab
#>>>: do not touch any code between this and the start comment. Checksum: 46da8ccba0874e95c56493dc07144692


Baz: zab
END
    $test->is_multiline_text( $output, $expected, 'We should be able to generate a nice rewritable template' );
}

sub test_errors {
    my $test = shift;
    my %args = (
        foo => 'oof',
        bar => 'rab',
        baz => undef,
    );
    throws_ok { template( 'example', \%args ) }
    qr/Undefined value in template path 'baz' in 'example' template./,
      'Processing a template with undef or missing fields should generate an error';
    $args{baz}   = 3;
    $args{extra} = 4;
    throws_ok { template( 'example', \%args ) }
    qr/The following variables were passed to the 'example' template but not used: extra/,
      'Processing a template with extra fields should generate an error';
}

1;
