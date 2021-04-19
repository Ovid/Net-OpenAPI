package My::Project::OpenAPI::Controller::Store;

use strict;
use warnings;
use Net::OpenAPI::App::Endpoint;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::Controller::Store - Net::OpenAPI controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

=cut

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: 37e06fd56a7e244b88902d6492157ec9

sub routes {
    return resolve_endpoints(
        'post /store/order',
        'get /store/inventory',
        'delete /store/order/{orderId}',
        'get /store/order/{orderId}',

    );
}

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: 37e06fd56a7e244b88902d6492157ec9

=head1 ROUTES


=head2 C<post /store/order>

Place a new order in the store

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'complete' => {'type' => 'boolean'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'petId' => {'example' => 198772,'format' => 'int64','type' => 'integer'},'quantity' => {'example' => 7,'format' => 'int32','type' => 'integer'},'shipDate' => {'format' => 'date-time','type' => 'string'},'status' => {'description' => 'Order Status','enum' => ['placed','approved','delivered'],'example' => 'approved','type' => 'string'}},'type' => 'object','xml' => {'name' => 'order'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters

    {
        accepts => ['application/json'],
        content => {'application/json' => {'schema' => {'properties' => {'complete' => {'type' => 'boolean'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'petId' => {'example' => 198772,'format' => 'int64','type' => 'integer'},'quantity' => {'example' => 7,'format' => 'int32','type' => 'integer'},'shipDate' => {'format' => 'date-time','type' => 'string'},'status' => {'description' => 'Order Status','enum' => ['placed','approved','delivered'],'example' => 'approved','type' => 'string'}},'type' => 'object','xml' => {'name' => 'order'}}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /store/order' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /store/order' },
    );
};

=head2 C<get /store/inventory>

Returns a map of status codes to quantities

=head2 Request Parameters



=head2 Response Parameters

    {
        accepts => ['application/json'],
        content => {'application/json' => {'schema' => {'additionalProperties' => {'format' => 'int32','type' => 'integer'},'type' => 'object'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /store/inventory' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /store/inventory' },
    );
};

=head2 C<delete /store/order/{orderId}>

For valid response try integer IDs with value < 1000. Anything above 1000 or nonintegers will generate API errors

=head2 Request Parameters

    {
        description => "ID of the order that needs to be deleted",
        in          => "path",
        name        => "orderId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters



=cut

endpoint 'delete /store/order/{orderId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'delete /store/order/{orderId}' },
    );
};

=head2 C<get /store/order/{orderId}>

For valid response try integer IDs with value <= 5 or > 10. Other values will generated exceptions

=head2 Request Parameters

    {
        description => "ID of order that needs to be fetched",
        in          => "path",
        name        => "orderId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'complete' => {'type' => 'boolean'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'petId' => {'example' => 198772,'format' => 'int64','type' => 'integer'},'quantity' => {'example' => 7,'format' => 'int32','type' => 'integer'},'shipDate' => {'format' => 'date-time','type' => 'string'},'status' => {'description' => 'Order Status','enum' => ['placed','approved','delivered'],'example' => 'approved','type' => 'string'}},'type' => 'object','xml' => {'name' => 'order'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /store/order/{orderId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /store/order/{orderId}' },
    );
};

1;