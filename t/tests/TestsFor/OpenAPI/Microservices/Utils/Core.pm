package TestsFor::OpenAPI::Microservices::Utils::Core;

# vim: textwidth=200

use Test::Class::Moose;
use OpenAPi::Microservices::Utils::Core ':all';

sub test_resolve_method {
    my $test = shift;

    my %results_for = (
        get => {
            '/pet/'                  => [ 'My::Project::Model::Pet',   'get' ],
            '/pet/findByStatus'      => [ 'My::Project::Model::Pet',   'get_findByStatus' ],
            '/pet/find-by-status'    => [ 'My::Project::Model::Pet',   'get_find_by_status' ],
            '/pet/findByTags'        => [ 'My::Project::Model::Pet',   'get_findByTags' ],
            '/pet/{petId}'           => [ 'My::Project::Model::Pet',   'with_args_get', [qw/petId/] ],
            '/store/inventory'       => [ 'My::Project::Model::Store', 'get_inventory' ],
            '/store/order/{orderId}' => [ 'My::Project::Model::Store', 'with_args_get_order', [qw/orderId/] ],
            '/user/login'            => [ 'My::Project::Model::User',  'get_login' ],
            '/user/logout'           => [ 'My::Project::Model::User',  'get_logout' ],
            '/user/{username}'       => [ 'My::Project::Model::User',  'with_args_get', [qw/username/] ],
        },
        delete => {
            '/pet/{petId}'           => [ 'My::Project::Model::Pet',   'with_args_delete',       ['petId'] ],
            '/store/order/{orderId}' => [ 'My::Project::Model::Store', 'with_args_delete_order', [qw/orderId/] ],
            '/store/order'           => [ 'My::Project::Model::Store', 'delete_order' ],
            '/store/order/'          => [ 'My::Project::Model::Store', 'delete_order' ],
            '/user/{username}'       => [ 'My::Project::Model::User',  'with_args_delete', ['username'] ],
        },
        post => {
            '/pet'                     => [ 'My::Project::Model::Pet',   'post' ],
            '/pet/{petId}'             => [ 'My::Project::Model::Pet',   'with_args_post',               ['petId'] ],
            '/pet/{petId}/uploadImage' => [ 'My::Project::Model::Pet',   'with_args_post___uploadImage', ['petId'] ],
            '/store/order'             => [ 'My::Project::Model::Store', 'post_order' ],
            '/user'                    => [ 'My::Project::Model::User',  'post' ],
            '/user/createWithList'     => [ 'My::Project::Model::User',  'post_createWithList' ],
        },
        put => {
            '/pet'             => [ 'My::Project::Model::Pet',  'put' ],
            '/user/{username}' => [ 'My::Project::Model::User', 'with_args_put', ['username'] ],
        },
    );

    my %seen;
    foreach my $http_method ( sort keys %results_for ) {
        my %result_for = $results_for{$http_method}->%*;
        foreach my $path ( sort keys %result_for ) {
            my ( $expected_package, $expected_method, $expected_args ) = $result_for{$path}->@*;
            $expected_args //= [];
            my ( $package, $method, $args ) = resolve_method( 'My::Project::Model', $http_method, $path );
            if ( $seen{$http_method}{$path}{$package}{$method}++ ) {
                croak("Oops! We already saw &$package\::$method via $http_method $path");
            }
            is $package, $expected_package,
              "$http_method $path should give us the correct package: $expected_package";
            is $method,       $expected_method, "... and it should give us the correct method: $expected_method";
            eq_or_diff $args, $expected_args,   "... and it should give us the correct arguments: @$expected_args";
        }
    }
}

1;
