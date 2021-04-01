package Net::OpenAPI::Builder::Method;

use Moo;
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::App::Types qw(
  ArrayRef
  HTTPMethod
  InstanceOf
  MethodName
  NonEmptyStr
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

has arguments => (
    is       => 'ro',
    isa      => ArrayRef [NonEmptyStr],
    required => 1,
);

sub to_string {
    my $self = shift;
    return template(
        'method',
        { map { $_ => $self->$_ } qw/name path http_method description/ }
    );
}

1;
