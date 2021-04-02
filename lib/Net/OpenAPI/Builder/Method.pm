package Net::OpenAPI::Builder::Method;

use Moo;
use Data::Dumper;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(tidy_code);
use String::Escape qw(quote);
use Scalar::Util qw(looks_like_number blessed);
use Net::OpenAPI::App::Types qw(
  ArrayRef
  Dict
  HTTPMethod
  HashRef
  InstanceOf
  MethodName
  NonEmptyStr
  Undef
);

has package => (
    is       => 'ro',
    isa      => InstanceOf ['Net::OpenAPI::Builder::Package'],
    weak_ref => 1,
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => MethodName,
    required => 1,
);

has path => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

has http_method => (
    is       => 'ro',
    isa      => HTTPMethod,
    required => 1,
);

has description => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

has parameters => (
    is  => 'ro',
    isa => Dict [
        request  => Undef | ArrayRef [HashRef],
        response => Undef | ArrayRef [HashRef],
    ],
    required => 1,
);

sub request_params {
    my $self   = shift;
    my $params = $self->parameters->{request} or return 'None';
    return $self->_format_params($params);
}

sub response_params {
    my $self   = shift;
    my $params = $self->parameters->{response} or return 'None';
    return $self->_format_params($params);
}

sub to_string {
    my $self = shift;
    return template(
        'method',
        {
            request_params  => $self->request_params,
            response_params => $self->response_params,
            path            => $self->path,
            http_method     => $self->http_method,
            description     => $self->description,
        }
    );
}

sub _format_params {

    # this ugly bit of code is designed to ensure that each component of a
    # parameter shows up on a single line in the docs. It makes them much
    # easier to read than the current sprawl.
    my ( $self, $params ) = @_;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Terse    = 1;
    my @params = @$params;
    my $docs   = '';
    foreach my $param (@params) {
        $docs .= "    {\n";
        my $max = $self->_max_length( keys %$param );
        foreach my $field ( sort keys %$param ) {
            my $value = $param->{$field};
            if ( blessed $value ) {
                $value = 0 + $value;    # JSON::PP::Boolean and friends
            }
            elsif ( ref $value ) {
                $value = Dumper($value);
            }
            elsif ( !looks_like_number($value) ) {
                $value = quote($value // 0);
            }
            $docs .= sprintf "        %-${max}s => $value,\n" => $field;
        }
        $docs .= "    }\n";
    }
    return $docs;
}

sub _max_length {
    my ( $self, @strings ) = @_;
    my $max = 0;
    for (@strings) {
        $max = length($_) if length($_) > $max;
    }
    return $max;
}

1;
