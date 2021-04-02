package TestsFor::Net::OpenAPI::App::Response;

# vim: textwidth=200

use Mojo::JSON 'decode_json';
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::StatusCodes qw(HTTPOK);
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_serialization {
    my $test = shift;

    my $body = {
        id       => 10,
        name     => "doggie",
        category => {
            id   => 1,
            name => "Dogs"
        },
        photoUrls => ["string"],
        tags      => [
            {
                id   => 0,
                name => "string"
            }
        ],
        status => "available"
    };
    ok my $response = $test->class_name->new(
        status_code => HTTPOK,
        body   => $body,
    ), 'We should be able to create a response object';
    eq_or_diff decode_json($response->to_json), $body, '... and our JSON should serialize correct';

    $DB::single = 1;
    explain $response->to_xml;
}

1;

__END__

<?xml version="1.0" encoding="UTF-8"?>
<pet>
	<id>10</id>
	<name>doggie</name>
	<category>
		<id>1</id>
		<name>Dogs</name>
	</category>
	<photoUrls>
		<photoUrl>string</photoUrl>
	</photoUrls>
	<tags>
		<tag>
			<id>0</id>
			<name>string</name>
		</tag>
	</tags>
	<status>available</status>
</pet>
