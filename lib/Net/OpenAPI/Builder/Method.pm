package Net::OpenAPI::Builder::Method;

use Moo;
use Data::Dumper;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::Core qw(tidy_code);
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

sub _format_params {
    my ( $self, $params ) = @_;
    local $Data::Dumper::Indent   = 1;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Terse    = 1;
    return tidy_code( Dumper($params) );
}

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
        { map { $_ => $self->$_ } qw/request_params response_params path http_method description/ }
    );
}

1;
