package Net::OpenAPI::Builder;

# ABSTRACT: Build our framework stub

use Moo;
use Mojo::File qw(path);

use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder::Package;
use Net::OpenAPI::Utils::Template qw(template write_template);
use Net::OpenAPI::Utils::File qw(write_file);
use Net::OpenAPI::App::Validator;

use Net::OpenAPI::Utils::Core qw(
  get_path_and_filename
  resolve_root
  tidy_code
);
use Net::OpenAPI::App::Types qw(
  Directory
  HashRef
  InstanceOf
  NonEmptyStr
  PackageName
);
use namespace::autoclean;

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
    isa     => InstanceOf ['Net::OpenAPI::App::Validator'],
    builder => sub {
        my $self = shift;
        return Net::OpenAPI::App::Validator->new( schema => $self->_schema );
    },
);

has dir => (
    is       => 'ro',
    isa      => Directory,
    required => 1,
);

has packages => (
    is      => 'ro',
    isa     => HashRef [ InstanceOf ['Net::OpenAPI::Builder::Package'] ],
    default => sub { {} },
);

sub _get_packages {
    my $self = shift;
    return values %{ $self->packages };
}

sub write {
    my $self   = shift;
    my $schema = $self->_validator->schema;

    if ( my @errors = $schema->errors->@* ) {
        my $errors = join "\n" => @errors;
        croak($errors);
    }

    my $routes = $schema->routes;
    my $base   = $self->base;
    my (%controllers, %models);
    $routes->each(
        sub {
            my ( $route, $num ) = @_;
            my $http_method = $route->{method};
            my $path        = $route->{path};
            my $root        = resolve_root($path);
            my $package     = $self->packages->{$root} //= Net::OpenAPI::Builder::Package->new( base => $base, root => $root );
            $controllers{ $package->controller_name } = 1;
            $models{ $package->model_name }           = 1;

            my $description
              = $schema->get(  [ "paths", $path, $http_method, "description" ] )
              || $schema->get( [ "paths", $path, $http_method, "summary" ] )
              || 'No description found';
            my $request_parameters  = $schema->parameters_for_request(  [ $http_method, $path ] );
            my $response_parameters = $schema->parameters_for_response( [ $http_method, $path ] );
            $package->add_method(
                http_method => $http_method,
                path        => $path,
                description => $description,
                parameters  => {
                    request  => $request_parameters,
                    response => $response_parameters,
                },
            );
        }
    );
    my $app = $self->base.'::App';
    my ( $path, $filename ) = get_path_and_filename( $self->dir, $app );
    my $app_code = write_template(
        path          => $path,
        file          => $filename,
        tidy          => 1,
        template_name => 'app',
        template_data => {
            package     => $app,
            models      => [ sort keys %models ],
            controllers => [ sort keys %controllers ],
            base        => $self->base,
        },
    );
    $_->write( $self->dir ) foreach $self->_get_packages;
    $self->_write_driver($app);
}

sub _write_driver {
    my ( $self, $app ) = @_;
    my $psgi_code = template(
        'psgi',
        { app => $app }
    );
    my $path = path( $self->dir . "/script" )->make_path;
    $path->make_path->child('app.psgi')->spurt($psgi_code);
}
1;
