package OpenAPi::Microservices::Builder;

# ABSTRACT: Build our framework stub

use v5.16.0;
use Moo;
use Mojo::File;
use JSON::Validator::Schema::OpenAPIv3;

use OpenAPI::Microservices::Types qw(
  InstanceOf
  NonEmptyStr
);

has _schema => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
    init_arg => 'schema',
);

has _validator => (
    is      => 'lazy',
    isa     => InstanceOf ['JSON::Validator::Schema::OpenAPIv3'],
    builder => sub {
        my $self = shift;
        return JSON::Validator::Schema::OpenAPIv3->new->schema(
            Mojo::File->new( $self->_schema ) );
    },
);

sub write {
    my $self   = shift;
    my $schema = $self->_validator->schema;

    if ( my $errors = $schema->errors ) {
        die $errors;
    }

    my $routes = $schema->routes;
    use DDP;
    p $routes;
    $routes->each(
        sub {
            my ( $e, $num ) = @_;
            say $e;
        }
    );
}

1;
