package TestsFor::Net::OpenAPI::Utils::Core;

# vim: textwidth=200

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Core ':all';
use Test::Class::Moose extends => 'Test::Net::OpenAPI';

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

            # 시티 is Korean for "city"
            '/시티' => [ 'My::Project::Model::Siti', 'get' ],
            '/日本/{city}', [ 'My::Project::Model::RiBen', 'with_args_get', [qw/city/] ],
        },
        delete => {
            '/pet/{petId}'           => [ 'My::Project::Model::Pet',   'with_args_delete',       ['petId'] ],
            '/store/order/{orderId}' => [ 'My::Project::Model::Store', 'with_args_delete_order', [qw/orderId/] ],
            '/store/order'           => [ 'My::Project::Model::Store', 'delete_order' ],
            '/store/order/'          => [ 'My::Project::Model::Store', 'delete_order' ],
            '/user/{username}' => [ 'My::Project::Model::User', 'with_args_delete', ['username'] ],
        },
        post => {
            '/pet'                     => [ 'My::Project::Model::Pet',   'post' ],
            '/pet/{petId}'             => [ 'My::Project::Model::Pet',   'with_args_post', ['petId'] ],
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
        my %result_for = %{ $results_for{$http_method} };
        foreach my $path ( sort keys %result_for ) {
            my ( $expected_package, $expected_method, $expected_args ) = @{ $result_for{$path} };
            $expected_args //= [];
            my $package = resolve_package( 'My::Project', 'Model', $path );
            my ( $method, $args ) = resolve_method( $http_method, $path );
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

sub test_get_path_prefix {
    my $test   = shift;
    my $prefix = get_path_prefix('/시티/foo');
    is $prefix, 'Siti', 'We should be able to fetch prefixes of paths';

    $prefix = get_path_prefix('/pet-Semetary/foo');
    is $prefix, 'PetSemetary', '... and get names suitable for using in classes';
}

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
1;
