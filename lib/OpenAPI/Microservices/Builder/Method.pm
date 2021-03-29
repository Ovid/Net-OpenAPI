package OpenAPI::Microservices::Builder::Method;

use Moo;
use OpenAPI::Microservices::Utils::Types qw(
  ArrayRef
  HTTPMethod
  InstanceOf
  MethodName
  NonEmptyStr
);
with qw(
  OpenAPI::Microservices::Builder::Role::ToString
);

has package => (
    is       => 'ro',
    isa      => InstanceOf ['OpenAPI::Microservices::Builder::Package'],
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

has arguments => (
    is       => 'ro',
    isa      => ArrayRef [NonEmptyStr],
    required => 1,
);

sub _fields { qw/name path http_method arguments/ }

sub _template {
    my $self = shift;
    return <<'END';
# [% http_method %] [% path %]
sub [% name %] {
    my $self        = shift;
    my $http_method = $self->http_method;
    my $path        = $self->path;
    my %arg_for     = @_;
    OpenAPI::Microservices::Exceptions::HTTP::NotImplemented->throw("$http_method $path");
}
END
}

1;
