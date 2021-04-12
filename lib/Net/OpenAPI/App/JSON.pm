package Net::OpenAPI::App::JSON;

# ABSTRACT: Encode/Decode JSON

use Net::OpenAPI::Policy;
use Cpanel::JSON::XS ();

use base 'Exporter';
our @EXPORT_OK = qw(
  encode_json
  decode_json
);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

=head1 FUNCTIONS

Functions are exported on demand, or all at once via ':all';

	use Net::OpenAPI::App::JSON qw(encode_json);
    use Net::OpenAPI::App::JSON qw(decode_json);
    use Net::OpenAPI::App::JSON qw(:all);

At the present time we're punting on Booleans.

=head2 C<encode_json>

    my $json = encode_json($perl_data_structure);

Encodes Perl data as JSON.

=cut

sub encode_json {
    my $perl_data = shift;
    return Cpanel::JSON::XS::encode_json($perl_data);
}

=head2 C<decode_json>

    my $perl_data_structure = decode_json($json);

Decodes JSON data to a Perl data structure.

=cut

sub decode_json {
    my $perl_data = shift;
    return Cpanel::JSON::XS::decode_json($perl_data);
}

1;
