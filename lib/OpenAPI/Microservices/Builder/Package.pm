package OpenAPI::Microservices::Builder::Package;

use Moo;

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder::Method;
use OpenAPi::Microservices::Utils::Core qw(resolve_method);
use OpenAPI::Microservices::Utils::Types qw(
  compile_named
  compile
  MethodName
  ArrayRef
  NonEmptyStr
  HTTPMethod
  InstanceOf
  HashRef
  PackageName
);

with qw(
  OpenAPI::Microservices::Builder::Role::ToString
);

has name => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has methods => (
    is       => 'ro',
    isa      => HashRef [ InstanceOf ['OpenAPI::Microservices::Builder::Method'] ],
    default  => sub { {} },
    init_arg => undef,
);

sub get_methods { return [ values %{ $_[0]->methods } ] }

sub _fields { qw/name get_methods/ }

sub _template {
    return <<'END';
package [% name %];

use strict;
use warnings;
use OpenAPI::Microservices::Exceptions::HTTP::NotImplemented;

[% FOREACH method IN get_methods %]
[% method.to_string %]
[% END %]

1;
END
}

sub has_method {
    my ( $self, $method_name ) = @_;
    state $check = compile(MethodName);
    ($method_name) = $check->($method_name);
    return exists $self->methods->{$method_name};
}

sub add_method {
    my $self = shift;
    state $check = compile_named(
        http_method => HTTPMethod,
        path        => NonEmptyStr,
    );
    my $arg_for = $check->(@_);

    my ( undef, $method_name, $args ) = resolve_method(
        $self->base,
        $arg_for->{http_method},
        $arg_for->{path},
    );

    if ( $self->has_method( $method_name ) ) {
        croak("Cannot re-add method '$arg_for->{method}'");
    }
    my $method = OpenAPI::Microservices::Builder::Method->new(
        package     => $self,
        name        => $method_name,
        path        => $arg_for->{path},
        http_method => $arg_for->{http_method},
        arguments   => ( $args || [] )
    );
    $self->methods->{$method_name} = $method;
    return $method;
}

1;
__END__
=for pod

post /pet (addPet)
    My::Project::OpenAPI::Model::Pet post
put /pet (updatePet)
    My::Project::OpenAPI::Model::Pet put
post /user (createUser)
    My::Project::OpenAPI::Model::User post
get /user/login (loginUser)
    My::Project::OpenAPI::Model::User get_login
get /user/logout (logoutUser)
    My::Project::OpenAPI::Model::User get_logout
post /store/order (placeOrder)
    My::Project::OpenAPI::Model::Store post_order
get /pet/findByTags (findPetsByTags)
    My::Project::OpenAPI::Model::Pet get_findByTags
get /store/inventory (getInventory)
    My::Project::OpenAPI::Model::Store get_inventory
get /pet/findByStatus (findPetsByStatus)
    My::Project::OpenAPI::Model::Pet get_findByStatus
post /user/createWithList (createUsersWithListInput)
    My::Project::OpenAPI::Model::User post_createWithList
delete /pet/{petId} (deletePet)
    My::Project::OpenAPI::Model::Pet args_delete petId
get /pet/{petId} (getPetById)
    My::Project::OpenAPI::Model::Pet args_get petId
post /pet/{petId} (updatePetWithForm)
    My::Project::OpenAPI::Model::Pet args_post petId
delete /user/{username} (deleteUser)
    My::Project::OpenAPI::Model::User args_delete username
get /user/{username} (getUserByName)
    My::Project::OpenAPI::Model::User args_get username
put /user/{username} (updateUser)
    My::Project::OpenAPI::Model::User args_put username
delete /store/order/{orderId} (deleteOrder)
    My::Project::OpenAPI::Model::Store args_delete_order orderId
get /store/order/{orderId} (getOrderById)
    My::Project::OpenAPI::Model::Store args_get_order orderId
post /pet/{petId}/uploadImage (uploadFile)
    My::Project::OpenAPI::Model::Pet args_post___uploadImage petId

=cut
