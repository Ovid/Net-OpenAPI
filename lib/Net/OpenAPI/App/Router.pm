package Net::OpenAPI::App::Router;

# ABSTRACT: Fast, lighweight router for Net::OpenAPI

use 5.16.0;
use Moo;
use Path::Router;
use Module::Runtime qw(require_module);
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  compile
  ArrayRef
  CodeRef
  Dict
  HashRef
  InstanceOf
  HTTPMethod
  MethodName
  OpenAPIPath
  PackageName
);
use Net::OpenAPI::Utils::Core qw(
  get_path_prefix
);

our $VERSION = '0.01';
my $verbose = 0;

has _router => (
    is      => 'lazy',
    isa     => InstanceOf ['Path::Router'],
    builder => sub { Path::Router->new },
);

has routes => (
    is       => 'ro',
    isa      => ArrayRef [ HashRef [ HashRef [CodeRef] ] ],
    required => 1,
);

sub BUILD {
    my $self   = shift;
    my $router = $self->_router;
    my $routes = $self->routes;
    foreach my $route_group ( @{ $self->routes } ) {
        while ( my ( $path, $target ) = each %$route_group ) {

            # XXX check for dups here?
            $router->add_route( $path, target => $target );
        }
    }
}

=head2 C<match>

    if ( my ( $target, $match ) = $router->match($request) ) {
        my $response = $target->($request);
        ...
    }

Accepts a L<Plack::Request> object and returns the coderef to dispatch to,
along with the L<Path::Router> object.

=cut

sub match {
    my ( $self, $req ) = @_;
    my $match = $self->_router->match( $req->path ) or return;
    my $code  = $match->target->{ lc $req->method } or return;
    return ( $code, $match );
}

1;
