# NAME

Net::OpenAPI - Build out the shell of a microservice from an OpenAPI definition

# VERSION

version 0.01

# SYNOPSIS

    use Net::OpenAPI::Policy;
    use Net::OpenAPI::Builder;

    my $builder = Net::OpenAPI::Builder->new(
        schema_file => 'data/v3-petstore.json',
        base        => 'My::Project::OpenAPI',
        dir         => 'target',
        api_base    => '/api/v1',
        doc_base    => '/api/docs',
        overwrite   => 0,
    );
    $builder->write;

# DESCRIPTION

The example in the `SYNOPSIS` builds out an OpenAPI server app shell in the
`target/`, directory, with a basename of 'My::Project::OpenAPI", using the
`data/v3-petstore.json` schema.

If you rerun the above code, it will _not_ overwrite the local changes you
have made to the endpoints.

Currently it only understands V3 JSON schemas (easy to fix?).

After it's done, assuming the schema was good, you can `cd` into the target
directory and run:

    $ plackup script/app.psgi
    # wait ...
    $ curl -v http://0:5000/api/v1/pet/23

You will get an Unimplemented error. Edit
`lib/My/Project/OpenAPI/Controller/Pet.pm` to return the desired data
structure and restart plack.

    endpoint 'get /pet/{petId}' => sub {
        my ( $request, $params ) = @_;

        # replace this code with your code
        return Net::OpenAPI::App::Response->new(
            status_code => HTTPNotImplemented,
            body        => {
                error => 'Not Implemented',
                code  => HTTPNotImplemented,
                info  => 'get /pet/{petId}',
            },
        );
    };

If you wish to see the full documentation for your project, visit:

    http://0:5000/api/docs

Documentation is generated with [Redoc](https://github.com/Redocly/redoc).

Currently we don't yet validate input or output. We'd prefer to use
[JSON::Validator::Schema::OpenAPIv3](https://metacpan.org/pod/JSON::Validator::Schema::OpenAPIv3)'s validation features for this.

# APOLOGIES

The documentation is currently very sparse. Our apologies.

# AUTHOR

Curtis "Ovid" Poe <ovid@allaroundtheworld.fr>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Curtis "Ovid" Poe.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
