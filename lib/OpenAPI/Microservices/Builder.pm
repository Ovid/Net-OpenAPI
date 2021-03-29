package OpenAPi::Microservices::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use Mojo::File;
use Mojo::JSON 'decode_json';
use JSON::Validator::Schema::OpenAPIv3;

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder::Package;

use OpenAPi::Microservices::Utils::Core qw(
  resolve_method
);
use OpenAPI::Microservices::Utils::Types qw(
  HashRef
  InstanceOf
  NonEmptyStr
  PackageName
);

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
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
        return JSON::Validator::Schema::OpenAPIv3->new( decode_json( $file->slurp ) );
    },
);

has to => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

has packages => (
    is      => 'ro',
    isa     => HashRef [ InstanceOf ['OpenAPI::Microservices::Builder::Package'] ],
    default => sub { {} },
);

sub write {
    my $self   = shift;
    my $schema = $self->_validator->schema;

    if ( my @errors = $schema->errors->@* ) {
        my $errors = join "\n" => @errors;
        croak($errors);
    }

    my $routes = $schema->routes;
    my $base = $self->base;
    $routes->each(
        sub {
            my ( $route, $num ) = @_;
            my $http_method  = $route->{method};
            my $operation_id = $route->{operation_id};
            my $path         = $route->{path};
            my ( $package_name, $method_name, $args ) = resolve_method(
                $base,
                $http_method,
                $path,
            );
            my $package = $self->packages->{$package_name} //= OpenAPI::Microservices::Builder::Package->new( name => $package_name, base => $base );
            my $method = $package->add_method(http_method=> $http_method, path => $path);
            say $method->to_string;
        }
    );
}

1;
