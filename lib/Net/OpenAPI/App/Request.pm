package Net::OpenAPI::App::Request;

use Moo;
use Net::OpenAPI::App::Types qw(HashRef);
extends 'Plack::Request';

has env => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);



sub FOREIGNBUILDARGS {
    my ( $class, %arg_for ) = @_;
    return $arg_for{env};
}

sub validation_data {
    my $self  = shift;
    my $query = $self->query_parameters;

    # only taking a single value because (it's unclear) that's what
    # JSON::Validator::Schema::OpenAPIv3 expects
    my %query = map { $_ => $query->get($_) } $query->keys;

    # https://metacpan.org/pod/JSON::Validator::Schema::OpenAPIv2#validate_request
    return (
        [ $self->method, $self->path_info ],
        {
            header => { @{ $self->headers->psgi_flatten_without_sort } },
            query  => \%query,
            body   => sub { $self->_body_validation },

            #formData => {email => "..."},
            #path => {id => "..."},
        }
    );
}

sub _body_validation {
    my ($self) = @_;

    my $content_type = lc $self->content_type || '';
    my $res          = { content_type => $content_type, exists => !!$self->content_length };

    if ( $self->_is_json ) {
        $res->{value} = decode_json( $self->content );
    }
    else {
        $res->{value} = $self->body_parameters;
    }

    return $res;
}

sub _is_multipart_formdata {
    my $self = shift;
    return $self->content_type =~ m{multipart/form-data}i;
}

sub _is_json {
    my $self = shift;
    return $self->content_type =~ m{application/json}i;
}

sub _is_url_encoded {
    my $self = shift;
    return $self->content_type =~ m{application/x-www-form-urlencoded}i;
}

1;

__END__


