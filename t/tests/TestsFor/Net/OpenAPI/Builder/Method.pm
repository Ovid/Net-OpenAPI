package TestsFor::Net::OpenAPI::Builder::Method;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Builder::Package;

sub test_create_package {
    my $test = shift;

    my $package = Net::OpenAPI::Builder::Package->new(
        base => 'My::Project',
        root => 'Pet',
    );

    ok my $method = $package->add_method(
        http_method => 'get',
        path        => '/pet/{itemId}',
        description => 'Get a room, will ya?',
        parameters  => {
            request => [
                { in => "query", name => "q" },
                { in => "body",  name => "body", accepts => ["application/json"] },
            ],
            response => [
                { in => "header", name => "X-Foo" },
                { in => "body",   name => "body", accepts => ["application/json"] },
            ]
        },
      ),
      'We should be able to add a method to our package';
    explain $method->to_string;
}

1;
