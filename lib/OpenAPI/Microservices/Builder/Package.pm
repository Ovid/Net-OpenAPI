package OpenAPI::Microservices::Builder::Package;

use Moo;

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder::Method;
use OpenAPI::Microservices::Utils::ReWrite;
use OpenAPI::Microservices::Utils::Core qw(resolve_method);
use OpenAPI::Microservices::Utils::Types qw(
  compile_named
  compile
  MethodName
  ArrayRef
  NonEmptyStr
  HTTPMethod
  InstanceOf
  HashRef
  PackageName
);

with qw(
  OpenAPI::Microservices::Builder::Role::ToString
);

has name => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has methods => (
    is       => 'ro',
    isa      => HashRef [ InstanceOf ['OpenAPI::Microservices::Builder::Method'] ],
    default  => sub { {} },
    init_arg => undef,
);

sub get_methods { return [ values %{ $_[0]->methods } ] }

sub _fields { qw/name get_methods routes/ }

sub routes {
        my $self = shift;
    
       my $code = '';
       my $controller = $self->name;
        foreach my $method ( @{$self->get_methods} ) {
            my $http_method = $method->http_method;
            my $path = $method->path;
            my $name = $method->name;
            $code .= "        { path => '$path', http_method => '$http_method', controller => '$controller',  action => '$name' },\n";
        }
        chomp($code);
        $code = <<"END";
sub routes {
    return (
$code
    );
}
END
    my $rewrite = OpenAPI::Microservices::Utils::ReWrite->new( new_text => $code );
    return $rewrite->rewritten;
}

sub _template {
    return <<'END';
package [% name %];

use strict;
use warnings;
use OpenAPI::Microservices::Exceptions::HTTP::NotImplemented;

[% routes %]

=head1 NAME

[% name %]

=head1 METHODS
[% FOREACH method IN get_methods %]
[% method.to_string %]
[% END %]

1;
END
}

sub has_method {
    my ( $self, $method_name ) = @_;
    state $check = compile(MethodName);
    ($method_name) = $check->($method_name);
    return exists $self->methods->{$method_name};
}

sub add_method {
    my $self = shift;
    state $check = compile_named(
        http_method => HTTPMethod,
        path        => NonEmptyStr,
    );
    my $arg_for = $check->(@_);

    my ( undef, $method_name, $args ) = resolve_method(
        $self->base,
        $arg_for->{http_method},
        $arg_for->{path},
    );

    if ( $self->has_method( $method_name ) ) {
        croak("Cannot re-add method '$arg_for->{method}'");
    }
    my $method = OpenAPI::Microservices::Builder::Method->new(
        package     => $self,
        name        => $method_name,
        path        => $arg_for->{path},
        http_method => $arg_for->{http_method},
        arguments   => ( $args || [] )
    );
    $self->methods->{$method_name} = $method;
    return $method;
}

1;
