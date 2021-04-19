package My::Project::OpenAPI::App;

use lib '../../lib';

#<<< do not touch any code between this and the end comment. Checksum: 3c19ff287a28c449d5318e60f11bb354
package My::Project::OpenAPI::App;

#<<< CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the end comment. Checksum: 3f30b4310b17c9de4c42431c6d769a1f

use v5.16.0;
use strict;
use warnings;
use Scalar::Util 'blessed';
use Plack::Request;

use Net::OpenAPI::App::JSON qw(encode_json);
use Net::OpenAPI::App::Router;
use Net::OpenAPI::App::StatusCodes qw(HTTPOK HTTPInternalServerError);
use My::Project::OpenAPI::App::Docs;

use My::Project::OpenAPI::Controller::Pet;
use My::Project::OpenAPI::Controller::Store;
use My::Project::OpenAPI::Controller::User;

my $routes = [
    My::Project::OpenAPI::Controller::Pet->routes,
    My::Project::OpenAPI::Controller::Store->routes,
    My::Project::OpenAPI::Controller::User->routes,
];

my $router = Net::OpenAPI::App::Router->new( routes => $routes );

sub get_app {
    return sub {
        my $req = Plack::Request->new(shift);
        my ( $action, $match ) = $router->match($req)
          or return $req->new_response(404)->finalize;

        my ( $result, $res );
        if ( eval { $result = $action->( $req, $match ); 1 } ) {
            if ( blessed $result && $result->isa('Net::OpenAPI::App::Response') ) {

                # they've returned a response object. Use it.
                $res = $req->new_response( $result->status_code );
                if ( my $body = $result->body ) {
                    $res->content_type('application/json');
                    $res->body( encode_json($body) );
                }
            }
            elsif ( ref $result ) {

                # they've returned a raw data structure as a shortcut. Use it.
                $res = $req->new_response(HTTPOK);
                $res->content_type('application/json');
                $res->body( encode_json($result) );
            }
        }
        else {
            # XXX eval failed. Need more info here.
            warn $@;
            $res = $req->new_response(HTTPInternalServerError);
        }
        return $res->finalize;
    };
}

sub doc_index {
    return sub {
        my $req = Plack::Request->new(shift);
        return My::Project::OpenAPI::App::Docs->index($req);
    };
}

#>>> CodeGen::Protection::Format::Perl 0.05. Do not touch any code between this and the start comment. Checksum: 3f30b4310b17c9de4c42431c6d769a1f


1;

__END__

=head1 NAME

My::Project::OpenAPI::App - Application module for My::Project::OpenAPI

=head1 SYNOPSIS

    use My::Project::OpenAPI::App;
    use Net::OpenAPI::App::Router;

    my $router = Net::OpenAPI::App::Router->new;
    $router->add_routes(My::Project::OpenAPI::App->routes)

=head1 METHODS

=head2 C<routes>

    my \$routes = My::Project::OpenAPI::App->routes;

Class method. Returns an array reference of routes you can pass to
C<&Net::OpenAPI::App::Router::add_routes>.
#>>> do not touch any code between this and the start comment. Checksum: 3c19ff287a28c449d5318e60f11bb354


1;

__END__

=head1 NAME

My::Project::OpenAPI::App - Application module for My::Project::OpenAPI

=head1 SYNOPSIS

    use My::Project::OpenAPI::App;
    use Net::OpenAPI::App::Router;

    my $router = Net::OpenAPI::App::Router->new;
    $router->add_routes(My::Project::OpenAPI::App->routes)

=head1 METHODS

=head2 C<routes>

    my \$routes = My::Project::OpenAPI::App->routes;

Class method. Returns an array reference of routes you can pass to
C<&Net::OpenAPI::App::Router::add_routes>.