package TestsFor::Net::OpenAPI::Utils::File;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Utils::File qw(:all);

sub test_unindent {
    my $test = shift;
    my $code = unindent(<<"    END");
    package Some::Package;
    
    use v5.16.0;
    use strict;
    use warnings;
        # keep this indentation
      # and this
    END
    my $expected = <<"END";
package Some::Package;

use v5.16.0;
use strict;
use warnings;
    # keep this indentation
  # and this
END
    is $code, $expected, 'unindent() should properly unindent our code';

    my $bad_indent = <<"    END";
    package Some::Package;
    
  use v5.16.0;
    use strict;
    use warnings;
        # keep this indentation
      # and this
    END
    throws_ok { unindent($bad_indent) }
      qr/\Qunindent() failed with line found with indentation less than '4'/,
      'Unindenting anything with a line whose leading whitespaces are less than first line should fail';
}

__PACKAGE__->meta->make_immutable;
