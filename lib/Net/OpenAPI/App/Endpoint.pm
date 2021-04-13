package Net::OpenAPI::App::Endpoint;

# ABSTRACT: Define Net::OpenAPI endpoints

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Core qw(trim);
use Net::OpenAPI::Utils::Core qw(
  resolve_endpoint
  openapi_to_path_router
);

use Sub::Name;
use Sub::Install 'install_sub';

sub import {
    my ( $class, %arg_for ) = @_;
    my $caller   = caller;
    my $endpoint = sub {
        my ( $name,          $sub )  = @_;
        my ( $http_method, $path, $function_name, $args ) = resolve_endpoint($name);
        print STDERR "# Installing endpoint '$name' into $caller as '$function_name'\n" if $arg_for{debug};
        subname "endpoint: $name" => $sub;
        install_sub(
            {
                code => $sub,
                into => $caller,
                as   => $function_name,
            }
        );
    };
    install_sub(
        {
            code => $endpoint,
            into => $caller,
            as   => 'endpoint',
        }
    );
    install_sub(
        {
            code => sub {
                my @endpoints = @_;

                my %routes;
                foreach my $endpoint (@endpoints) {
                    my $endpoint = shift;
                    my ( $http_method, $path, $function_name, undef ) = resolve_endpoint($endpoint);
                    $path = openapi_to_path_router($path);
                    my $fq_name = "${caller}::${function_name}";
                    print STDERR "# Attemping to resolve endpoint '$endpoint' from $caller as '$function_name'\n" if $arg_for{debug};
                    no strict 'refs';
                    if ( defined( my $coderef = *{$fq_name}{CODE} ) ) {
                        $routes{$path}{$http_method} = $coderef;
                    }
                    else {
                        croak("Cannot dispatch to non-existent endpoint '$endpoint'");
                    }
                }
                return \%routes;
              },
            into => $caller,
            as   => 'resolve_endpoints',
        }
    );
}

1;

__END__

=head1 SYNOPSIS

    use Net::OpenAPI::App::Endpoint;
    use namespace::autoclean;

    endpoint 'DELETE /pet/{petId}' => sub {
        # deletion code here
    };

    endpoint 'GET /pet/{petId}' => sub {
        # get code here
    };

    my $code = resolve_endpoint('GET /pet/{petId}');
    $code->(@_); # calls the appropriate endpoint

=head1 DESCRIPTION

This module automatically exports two functions, C<endpoint> for declaring the
subroutine that handles an endpoint, and C<resolve_endpoints>, which returns
the declared subroutine.

=head1 FUNCTIONS

=head2 C<endpoint($endpoint_name, $coderef)>

    endpoint 'delete /pet/{petId}' => sub {
        my ( $request, $params ) = @_;
        return Net::OpenAPI::App::Response->new(
            status_code => HTTPNotImplemented,
            body        => { error => 'Not Implemented', code => HTTPNotImplemented, info => 'delete /pet/{petId}' },
        );
    };

This function takes a string matching an HTTP method and an OpenAPI path and
installs a sub that C<Net::OpenAPI::App::Router> knows how to call.

If you are developing with this and need to debug it, use this:

    use Net::OpenAPI::App::Endpoint debug => 1;

That will print to C<STDERR> each endpoint and the sub it is mapped to.

	# Installing endpoint 'get /pet/findByStatus' into My::OpenAPI::Model::Pet as 'get_findByStatus'
	# Installing endpoint 'get /pet/findByTags' into My::OpenAPI::Model::Pet as 'get_findByTags'
	# Installing endpoint 'get /pet/{petId}' into My::OpenAPI::Model::Pet as 'with_args_get'

=head2 C<resolve_endpoint($endpoint_name)>

    my $coderef = resolve_endpoint('delete /pet/{petId}');

Returns a reference to the code declared by C<endpoint($name,$code)>. If the code has not yet been
declared, will croak with an appropriate error message.

If you are developing with this and need to debug it, use this:

    use Net::OpenAPI::App::Endpoint debug => 1;

That will print to C<STDERR> attempts to resolve endpoints:

	# Attemping to resolve endpoint 'get /pet/{petId}' from My::OpenAPI::Model::Pet as 'with_args_get'
