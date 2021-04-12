package My::Project::OpenAPI::Controller::User;

use strict;
use warnings;
use Net::OpenAPI::App::Endpoint;
use Net::OpenAPI::App::Response;
use Net::OpenAPI::App::StatusCodes ':all';

=head1 NAME

My::Project::OpenAPI::Controller::User - Net::OpenAPI controller

=head1 DESCRIPTION

This controller merely declares the OpenAPI routes. This is used by the
L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

L<Net::OpenAPI::App::Router> at compile time to determine which
model and method incoming requests are directed to.

=cut

#<<< do not touch any code between this and the end comment. Checksum: aba625e550ebbaa5b02b78d9a032c0ab
sub routes {
    return resolve_endpoints(
        'post /user',
        'get /user/login',
        'get /user/logout',
        'delete /user/{username}',
        'get /user/{username}',
        'put /user/{username}',
        'post /user/createWithList',
        
    );
}
#>>> do not touch any code between this and the start comment. Checksum: aba625e550ebbaa5b02b78d9a032c0ab

=head1 ROUTES


=head2 C<post /user>

This can only be done by the logged in user.

=head2 Request Parameters

    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /user' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /user' },
    );
};

=head2 C<get /user/login>

Logs user into the system

=head2 Request Parameters

    {
        description => "The user name for login",
        in          => "query",
        name        => "username",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        description => "The password for login in clear text",
        in          => "query",
        name        => "password",
        required    => 0,
        schema      => {'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters

    {
        description => "date in UTC when toekn expires",
        in          => "header",
        name        => "X-Expires-After",
        schema      => {'format' => 'date-time','type' => 'string'},
    }
    {
        description => "calls per hour allowed by the user",
        in          => "header",
        name        => "X-Rate-Limit",
        schema      => {'format' => 'int32','type' => 'integer'},
    }
    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'type' => 'string'}},'application/xml' => {'schema' => {'type' => 'string'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /user/login' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /user/login' },
    );
};

=head2 C<get /user/logout>

Logs out current logged in user session

=head2 Request Parameters



=head2 Response Parameters



=cut

endpoint 'get /user/logout' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /user/logout' },
    );
};

=head2 C<delete /user/{username}>

This can only be done by the logged in user.

=head2 Request Parameters

    {
        description => "The name that needs to be deleted",
        in          => "path",
        name        => "username",
        required    => 1,
        schema      => {'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters



=cut

endpoint 'delete /user/{username}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'delete /user/{username}' },
    );
};

=head2 C<get /user/{username}>

Get user by user name

=head2 Request Parameters

    {
        description => "The name that needs to be fetched. Use user1 for testing. ",
        in          => "path",
        name        => "username",
        required    => 1,
        schema      => {'type' => 'string'},
        type        => "string",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'get /user/{username}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'get /user/{username}' },
    );
};

=head2 C<put /user/{username}>

This can only be done by the logged in user.

=head2 Request Parameters

    {
        description => "name that need to be deleted",
        in          => "path",
        name        => "username",
        required    => 1,
        schema      => {'type' => 'string'},
        type        => "string",
    }
    {
        accepts  => ['application/json','application/x-www-form-urlencoded','application/xml'],
        content  => {'application/json' => {'schema' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}}},'application/x-www-form-urlencoded' => {'schema' => $VAR1->{'application/json'}{'schema'}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters



=cut

endpoint 'put /user/{username}' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'put /user/{username}' },
    );
};

=head2 C<post /user/createWithList>

Creates list of users with given input array

=head2 Request Parameters

    {
        accepts  => ['application/json'],
        content  => {'application/json' => {'schema' => {'items' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}},'type' => 'array'}}},
        in       => "body",
        name     => "body",
        required => "0",
    }


=head2 Response Parameters

    {
        accepts => ['application/json','application/xml'],
        content => {'application/json' => {'schema' => {'properties' => {'email' => {'example' => 'john@email.com','type' => 'string'},'firstName' => {'example' => 'John','type' => 'string'},'id' => {'example' => 10,'format' => 'int64','type' => 'integer'},'lastName' => {'example' => 'James','type' => 'string'},'password' => {'example' => '12345','type' => 'string'},'phone' => {'example' => '12345','type' => 'string'},'userStatus' => {'description' => 'User Status','example' => 1,'format' => 'int32','type' => 'integer'},'username' => {'example' => 'theUser','type' => 'string'}},'type' => 'object','xml' => {'name' => 'user'}}},'application/xml' => {'schema' => $VAR1->{'application/json'}{'schema'}}},
        in      => "body",
        name    => "body",
    }


=cut

endpoint 'post /user/createWithList' => sub {
    my ( $request, $params ) = @_;
    return Net::OpenAPI::App::Response->new(
        status_code => HTTPNotImplemented,
        body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'post /user/createWithList' },
    );
};

1;