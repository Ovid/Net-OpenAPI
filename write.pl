#!/usr/bin/env perl

use lib 'lib';
use OpenAPI::Microservices::Policy;
use OpenAPi::Microservices::Builder;
use Mojo::Path;

my $path = Mojo::Path->new('/foo%2Fbar%3B/baz.html');
say $path->[0];

my $builder = OpenAPi::Microservices::Builder->new(
    schema => 'data/v3-petstore.json',
    to     => 'target',
);
$builder->write;

__END__

post     /pet                       (addPet)
put      /pet                       (updatePet)
post     /user                      (createUser)
get      /user/login                (loginUser)
post     /store/order               (placeOrder)
get      /user/logout               (logoutUser)
get      /pet/findByTags            (findPetsByTags)
get      /store/inventory           (getInventory)
get      /pet/findByStatus          (findPetsByStatus)
post     /user/createWithList       (createUsersWithListInput)
delete   /pet/{petId}               (deletePet)
get      /pet/{petId}               (getPetById)
post     /pet/{petId}               (updatePetWithForm)
delete   /user/{username}           (deleteUser)
get      /user/{username}           (getUserByName)
put      /user/{username}           (updateUser)
delete   /store/order/{orderId}     (deleteOrder)
get      /store/order/{orderId}     (getOrderById)
post     /pet/{petId}/uploadImage   (uploadFile)
