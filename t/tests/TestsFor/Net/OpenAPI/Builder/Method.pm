package TestsFor::Net::OpenAPI::Builder::Method;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::Builder::Package;

sub test_create_package {
    my $test = shift;

    my $package = Net::OpenAPI::Builder::Package->new(
        name => 'My::Project::Model::Store',
        base => 'My::Project::Model',
    );

    ok my $method = $package->add_method(
        http_method => 'get',
        path        => '/get/{itemId}',
        description => 'Get a room, will ya?',
      ),
      'We should be able to add a method to our package';
    explain $method->to_string;
}

1;
