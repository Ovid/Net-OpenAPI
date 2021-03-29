package TestsFor::OpenAPI::Microservices::Builder::Package;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';

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
      ),
      'We should be able to add a method to our package';
    explain $method->to_string;
}

1;
