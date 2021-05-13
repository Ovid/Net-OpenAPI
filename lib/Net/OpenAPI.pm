package Net::OpenAPI;

# ABSTRACT: Build out the shell of a microservice from an OpenAPI definition

our $VERSION = '0.01';

1;

__END__

=head1 SYNOPSIS

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

=head1 DESCRIPTION

The example in the C<SYNOPSIS> builds out an OpenAPI server app shell in the
C<target/>, directory, with a basename of 'My::Project::OpenAPI", using the
C<data/v3-petstore.json> schema.

If you rerun the above code, it will I<not> overwrite the local changes you
have made to the endpoints.

Currently it only understands V3 JSON schemas (easy to fix?).

After it's done, assuming the schema was good, you can C<cd> into the target
directory and run:

    $ plackup script/app.psgi
    # wait ...
    $ curl -v http://0:5000/api/v1/pet/23

You will get an Unimplemented error. Edit
C<lib/My/Project/OpenAPI/Controller/Pet.pm> to return the desired data
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

Currently we don't yet validate input or output. We'd prefer to use
L<JSON::Validator::Schema::OpenAPIv3>'s validation features for this.

=head1 APOLOGIES

The documentation is currently very sparse. Our apologies.
