package My::Project::OpenAPI::Controller::Pet;

use strict;
use warnings;
use Net::OpenAPI::App::Endpoint;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::Controller::Pet - Net::OpenAPI controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

=cut

#<<< do not touch any code between this and the end comment. Checksum: ba63f07a5e8930a40d5a741b5d6ae22d
package My::Project::OpenAPI::Controller::Pet;

use strict;
use warnings;
use Net::OpenAPI::App::Endpoint;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::Controller::Pet - Net::OpenAPI controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

=cut

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: a3006b89faab47c26ad26de8537abf3c

sub routes {
    return resolve_endpoints(
        'post /pet',
        'put /pet',
        'delete /pet/{petId}',
        'get /pet/{petId}',
        'post /pet/{petId}',
        'get /pet/findByTags',
        'get /pet/findByStatus',
        'post /pet/{petId}/uploadImage',

    );
}

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: a3006b89faab47c26ad26de8537abf3c

=head1 ROUTES


=head2 C<post /pet>

Add a new pet to the store

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => 1,
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /pet' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet' },
    );
};

=head2 C<put /pet>

Update an existing pet by Id

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => 1,
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'put /pet' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'put /pet' },
    );
};

=head2 C<delete /pet/{petId}>

Deletes a pet

=head2 Request Parameters

    {
        description => "",
        in          => "header",
        name        => "api_key",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        description => "Pet id to delete",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters



=cut

endpoint 'delete /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'delete /pet/{petId}' },
    );
};

=head2 C<get /pet/{petId}>

Returns a single pet

=head2 Request Parameters

    {
        description => "ID of pet to return",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /pet/{petId}' },
    );
};

=head2 C<post /pet/{petId}>

Updates a pet in the store with form data

=head2 Request Parameters

    {
        description => "ID of pet that needs to be updated",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }
    {
        description => "Name of pet that needs to be updated",
        in          => "query",
        name        => "name",
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        description => "Status of pet that needs to be updated",
        in          => "query",
        name        => "status",
        schema      => {'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters



=cut

endpoint 'post /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet/{petId}' },
    );
};

=head2 C<get /pet/findByTags>

Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.

=head2 Request Parameters

    {
        description => "Tags to filter by",
        explode     => 1,
        in          => "query",
        name        => "tags",
        required    => 0,
        schema      => {'items' => {'type' => 'string'},'type' => 'array'},
        type        => "array",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'items' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}},'type' => 'array'}},'application/xml' => {'schema' => {'items' => $VAR1->{'application/json'}{'schema'}{'items'},'type' => 'array'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/findByTags' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /pet/findByTags' },
    );
};

=head2 C<get /pet/findByStatus>

Multiple status values can be provided with comma separated strings

=head2 Request Parameters

    {
        description => "Status values that need to be considered for filter",
        explode     => 1,
        in          => "query",
        name        => "status",
        required    => 0,
        schema      => {'default' => 'available','enum' => ['available','pending','sold'],'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'items' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}},'type' => 'array'}},'application/xml' => {'schema' => {'items' => $VAR1->{'application/json'}{'schema'}{'items'},'type' => 'array'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/findByStatus' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /pet/findByStatus' },
    );
};

=head2 C<post /pet/{petId}/uploadImage>

uploads an image

=head2 Request Parameters

    {
        description => "ID of pet to update",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }
    {
        description => "Additional Metadata",
        in          => "query",
        name        => "additionalMetadata",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        accepts  => ['application/octet-stream'],
        content  => {'application/octet-stream' => {'schema' => {'format' => 'binary','type' => 'string'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters

    {
        accepts => ['application/json'],
        content => {'application/json' => {'schema' => {'properties' => {'code' => {'format' => 'int32','type' => 'integer'},'message' => {'type' => 'string'},'type' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => '##default'}}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /pet/{petId}/uploadImage' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet/{petId}/uploadImage' },
    );
};

1;
#>>> do not touch any code between this and the start comment. Checksum: ba63f07a5e8930a40d5a741b5d6ae22d

=head1 ROUTES


=head2 C<post /pet>

Add a new pet to the store

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => 1,
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /pet' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet' },
    );
};

=head2 C<put /pet>

Update an existing pet by Id

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => 1,
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'put /pet' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'put /pet' },
    );
};

=head2 C<delete /pet/{petId}>

Deletes a pet

=head2 Request Parameters

    {
        description => "",
        in          => "header",
        name        => "api_key",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        description => "Pet id to delete",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters



=cut

endpoint 'delete /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'delete /pet/{petId}' },
    );
};

=head2 C<get /pet/{petId}>

Returns a single pet

=head2 Request Parameters

    {
        description => "ID of pet to return",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    my $response = {
        id       => $params->mapping->{petId},
        name     => "doggie",
        category => {
            id   => 1,
            name => "Dogs"
        },
        photoUrls => ["string"],
        tags      => [ {} ],
        status    => "available"
    };
    return $response;
};

=head2 C<post /pet/{petId}>

Updates a pet in the store with form data

=head2 Request Parameters

    {
        description => "ID of pet that needs to be updated",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }
    {
        description => "Name of pet that needs to be updated",
        in          => "query",
        name        => "name",
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        description => "Status of pet that needs to be updated",
        in          => "query",
        name        => "status",
        schema      => {'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters



=cut

endpoint 'post /pet/{petId}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet/{petId}' },
    );
};

=head2 C<get /pet/findByTags>

Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.

=head2 Request Parameters

    {
        description => "Tags to filter by",
        explode     => 1,
        in          => "query",
        name        => "tags",
        required    => 0,
        schema      => {'items' => {'type' => 'string'},'type' => 'array'},
        type        => "array",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'items' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}},'type' => 'array'}},'application/xml' => {'schema' => {'items' => $VAR1->{'application/json'}{'schema'}{'items'},'type' => 'array'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/findByTags' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /pet/findByTags' },
    );
};

=head2 C<get /pet/findByStatus>

Multiple status values can be provided with comma separated strings

=head2 Request Parameters

    {
        description => "Status values that need to be considered for filter",
        explode     => 1,
        in          => "query",
        name        => "status",
        required    => 0,
        schema      => {'default' => 'available','enum' => ['available','pending','sold'],'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'items' => {'properties' => {'category' => {'properties' => {'id' => {'example' => 1,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'Dogs','type' => 'string'}},'type' => 'object','xml' => {'name' => 'category'}},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'name' => {'example' => 'doggie','type' => 'string'},'photoUrls' => {'items' => {'type' => 'string','xml' => {'name' => 'photoUrl'}},'type' => 'array','xml' => {'wrapped' => 1}},'status' => {'description' => 'pet status in the store','enum' => ['available','pending','sold'],'type' => 'string'},'tags' => {'items' => {'properties' => {'id' => {'format' => 'int64','type' => 'integer'},'name' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => 'tag'}},'type' => 'array','xml' => {'wrapped' => 1}}},'required' => ['name','photoUrls'],'type' => 'object','xml' => {'name' => 'pet'}},'type' => 'array'}},'application/xml' => {'schema' => {'items' => $VAR1->{'application/json'}{'schema'}{'items'},'type' => 'array'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /pet/findByStatus' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /pet/findByStatus' },
    );
};

=head2 C<post /pet/{petId}/uploadImage>

uploads an image

=head2 Request Parameters

    {
        description => "ID of pet to update",
        in          => "path",
        name        => "petId",
        required    => 1,
        schema      => {'format' => 'int64','type' => 'integer'},
        type        => "integer",
    }
    {
        description => "Additional Metadata",
        in          => "query",
        name        => "additionalMetadata",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        accepts  => ['application/octet-stream'],
        content  => {'application/octet-stream' => {'schema' => {'format' => 'binary','type' => 'string'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters

    {
        accepts => ['application/json'],
        content => {'application/json' => {'schema' => {'properties' => {'code' => {'format' => 'int32','type' => 'integer'},'message' => {'type' => 'string'},'type' => {'type' => 'string'}},'type' => 'object','xml' => {'name' => '##default'}}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /pet/{petId}/uploadImage' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /pet/{petId}/uploadImage' },
    );
};

1;