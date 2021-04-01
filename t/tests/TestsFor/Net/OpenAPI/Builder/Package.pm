package TestsFor::Net::OpenAPI::Builder::Package;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';

sub test_create_package {
    my $test = shift;

    ok my $package = $test->class_name->new(
        name => 'My::Project::Model::Store',
        base => 'My::Project::Model',
      ),
      'We should be able to create a package object';
    is $package->name, 'My::Project::Model::Store', '... and it should return its package name';

    ok my $method = $package->add_method(
        http_method => 'get',
        path        => '/get/{itemId}',
        description => 'Get a room, will ya?',
      ),
      'We should be able to add a method to our package';
    ok $method = $package->add_method(
        http_method => 'post',
        path        => '/create',
        description => 'Make it so!',
      ),
      'We should be able to add a method to our package';
    explain $package->_get_model_code('target');
}

1;
