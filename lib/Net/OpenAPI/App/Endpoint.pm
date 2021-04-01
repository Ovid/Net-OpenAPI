package Net::OpenAPI::App::Endpoint;

# ABSTRACT: Define Net::OpenAPI endpoints

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Core qw(trim);
use Net::OpenAPI::App::Types qw(
    compile
    HTTPMethod
    OpenAPIPath
);
use Net::OpenAPI::Utils::Core qw(
  resolve_method
);

use Sub::Name;
use Sub::Install 'install_sub';

sub import {
    my $caller   = caller;
    state $check = compile(HTTPMethod, OpenAPIPath);
    my $endpoint = sub {
        my ( $name, $sub ) = @_;
        my ( $http_method, $path ) = split /\s+/ => trim($name), 2;
        $http_method = lc $http_method;
        ($http_method, $path) = $check->($http_method, $path);
        my ( undef, $function_name, undef ) = resolve_method(
            'X',
            $http_method,
            $path,
        );
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

=head1 DESCRIPTION

This module automatically exports one function, C<endpoint>. This function takes a string

