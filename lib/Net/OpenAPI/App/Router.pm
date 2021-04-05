package Net::OpenAPI::App::Router;

# ABSTRACT: Fast, lighweight router for Net::OpenAPI

use 5.16.0;
use Moo;
use Module::Runtime qw(require_module);
use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  compile
  ArrayRef
  Dict
  HashRef
  HTTPMethod
  MethodName
  OpenAPIPath
  PackageName
);
use Net::OpenAPI::Utils::Core qw(
  get_path_prefix
);

my $verbose = 0;

has routes => (
    is  => 'ro',
    isa => ArrayRef [
        Dict [
            path        => OpenAPIPath,
            http_method => HTTPMethod,
            controller  => PackageName,
            method      => MethodName,
        ]
    ],
    required => 1,
);

has _route_cache => (
    is      => 'lazy',
    isa     => HashRef,
    builder => sub {
        my $self        = shift;
        my $route_cache = {};

        for my $route ( @{ $self->routes } ) {
            my $path = $route->{path};
            $path =~ s/\/$//;    # strip trailing slash if needed
            my $prefix        = get_path_prefix($path);
            my $segments      = $path =~ tr{/}{/};
            my $http_method   = uc $route->{http_method};
            my $cached_routes = $route_cache->{$http_method} //= {};

            if ( exists $cached_routes->{$segments}{$prefix}{$path} ) {
                croak("Route for $http_method $path already registered");
            }
            if ($verbose) {
                say STDERR "Registered route $http_method $path ($prefix)";
            }
            $cached_routes->{$segments}{$prefix}{$path} = $route;
        }
        return $route_cache;
    },
);

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
    state $dispatch_cache = {};
    my $match = $self->_match($req) or return;

    my ( $package, $function ) = @{$match}{qw/controller method/};
    unless ( exists $dispatch_cache->{$package}{$function} ) {

        # it's not in the dispatch cache, so let's load the module
        # and grab the action we're dispatching to.
        require_module($package);
        my $fq_name = "${package}::${function}";
        no strict 'refs';
        unless ( defined *{$fq_name}{CODE} ) {
            croak("Cannot dispatch to non-existent sub ($fq_name)");
        }
        $dispatch_cache->{$package}{$function} = *{$fq_name}{CODE};
    }
    $match->{dispatch} = $dispatch_cache->{$package}{$function};
    return $match;
}

sub _match {
    my ( $self, $req ) = @_;

    # routes are keyed by:
    #
    # $self->_route_cache->{$http_method}{$num_segments}{$prefix}{$path}

    my $path = $req->path;
    $path =~ s/\/$//;    # strip trailing slash if needed
    my $prefix    = get_path_prefix($path);
    my $segments  = $path =~ tr{/}{/};
    my $route_for = $self->_route_cache->{ $req->method }{$segments}{$prefix} or return;

    my $matched = 0;
    my @candidate_matches;
    PATH: foreach my $this_path ( keys %$route_for ) {
        my @new    = split '/' => $path;
        my @stored = split '/' => $this_path;

        unless ( @new == @stored ) {
            croak("PANIC: should never happen. $path and $this_path lengths do not match");
        }

        $matched = 1;
        my %param;
        SEGMENT: for my $i ( 0 .. $#new ) {
            if ( $stored[$i] =~ /^{(?<arg>[^}]+)}/ ) {    # it's a param, so it always matches
                $param{ $+{arg} } = $new[$i];
                next SEGMENT;
            }
            elsif ( $stored[$i] ne $new[$i] ) {
                $matched = 0;
                last SEGMENT;
            }
        }
        if ( $matched && !keys %param ) {
            my $match = $route_for->{$this_path};
            return { %$match, uri_params => {} };
        }
        else {
            # XXX OpenAPI doesn't forbid "ambiguous" paths, but clearly they exist
            # and it's hard to know, up front, what to do about it. However,
            # if we don't have an exact match, we fall back to "candidate"
            # matches and return the first one, but this is hash-ordered and
            # thus not deterministic. We need a better solution.
            # But for candidate matches, if only use routes with parameters
            # because if there was an exact match, we would already have had
            # it
            # https://github.com/OAI/OpenAPI-Specification/issues/2356
            if ( keys %param ) {

                # we have parameters, so this is not an exact match and might
                # be a candidate for matching.
                push @candidate_matches => [ $route_for->{$this_path}, \%param ];
            }
        }
    }
    my $candidate = shift @candidate_matches;
    return { %{ $candidate->[0] }, uri_params => $candidate->[1] };
}

1;
