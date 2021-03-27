package OpenAPi::Microservices::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use Mojo::File;
use Mojo::JSON 'decode_json';
use JSON::Validator::Schema::OpenAPIv3;

use OpenAPI::Microservices::Policy;

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
        my $file = Mojo::File->new( $self->_schema );
        return JSON::Validator::Schema::OpenAPIv3->new(
            decode_json( $file->slurp ) );
    },
);

has to => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

sub write {
    my $self   = shift;
    my $schema = $self->_validator->schema;

    if ( my @errors = $schema->errors->@* ) {
        my $errors = join "\n" => @errors;
        croak($errors);
    }

    my $routes = $schema->routes;
    $routes->each(
        sub {
            my ( $route, $num ) = @_;
            my $method       = $route->{method};
            my $operation_id = $route->{operation_id};
            my $path         = $route->{path};
            say "$method $path ($operation_id)";
        }
    );
}

1;
