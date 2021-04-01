package Net::OpenAPI::App::Router;

# ABSTRACT: Fast, lighweight router for Net::OpenAPI

use 5.16.0;
use Moo;
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  compile
  Dict
  HTTPMethod
  MethodName
  OpenAPIPath
  PackageName
);
use Net::OpenAPI::Utils::Core qw(
  get_path_prefix
);

has _routes => (
    is      => 'ro',
    default => sub { {} },
);

=head2 C<add_route(\%route, $verbose)>

    my $router = Net::OpenAPI::App::Router->new;
    $router->add_route(
        {
            http_method => $http_method,
            path        => $path,
            dispatch_to => $class_name,
            method      => $method,
        }
    );

Adds the given route to our router. If passed a second, true value, will
print the route to STDERR.

=cut

sub add_route {
    my ( $self, $route, $verbose ) = @_;
    state $check = compile(
        Dict [
            path        => OpenAPIPath,
            http_method => HTTPMethod,
            dispatch_to => PackageName,
            method      => MethodName,
        ]
    );
    ($route) = $check->($route);

    my $routes = $self->_routes;    # reference, so this mutates
    my $path   = $route->{path};
    $path =~ s/\/$//;               # strip trailing slash if needed
    my $prefix       = get_path_prefix($path);
    my $segments     = $path =~ tr{/}{/};
    my $http_method  = uc $route->{http_method};
    my $these_routes = $routes->{$http_method} //= {};

    if ( exists $these_routes->{$segments}{$prefix}{$path} ) {
        croak("Route for $http_method $path already added");
    }
    if ($verbose) {
        say STDERR "Added route $http_method $path ($prefix)";
    }
    $these_routes->{$segments}{$prefix}{$path} = $route;
}

=head2 C<match>

    if ( my $route = $router->match($request) ) {
        ...
    }

Accepts a L<Plack::Request> object and returns a route as passed in to
C<add_route>. Exact matches will be returned before inexact matches (e.g.,
C</pet/getAll> before C</pet/{PetId}>).

If more than one inexact match is found, returns one effectively randomly
(hash order). This is temporary and will be fixed later.

=cut

sub match {
    my ( $self, $req ) = @_;

    # routes are keyed by:
    #
    # $self->_routes->{$http_method}{$num_segments}{$prefix}{$path}

    my $path = $req->path;
    $path =~ s/\/$//;    # strip trailing slash if needed
    my $prefix    = get_path_prefix($path);
    my $segments  = $path =~ tr{/}{/};
    my $route_for = $self->_routes->{ $req->method }{$segments}{$prefix} or return;

    my $matched = 0;
    my @matches;
    PATH: foreach my $this_path ( keys %$route_for ) {
        my @new    = split '/' => $path;
        my @stored = split '/' => $this_path;

        unless ( @new == @stored ) {
            croak("PANIC: should never happen. $path and $this_path lengths do not match");
        }

        $matched = 1;
        my $exact_match = 1;
        SEGMENT: for my $i ( 0 .. $#new ) {
            if ( $stored[$i] =~ /^{/ ) {    # it's a param, so it always matches
                $exact_match = 0;
                next SEGMENT;
            }
            elsif ( $stored[$i] ne $new[$i] ) {
                $matched = 0;
                last SEGMENT;
            }
        }
        if ( $matched && $exact_match ) {
            return $route_for->{$this_path};
        }
        else {
            push @matches => $route_for->{$this_path};
        }
    }
    return shift @matches;
}

1;
