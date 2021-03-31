package OpenAPI::Microservices::Builder::Package;

use Moo;

use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Builder::Method;
use OpenAPI::Microservices::Utils::ReWrite;
use OpenAPI::Microservices::Utils::Core qw(resolve_method tidy_code);
use OpenAPI::Microservices::Utils::Template qw(template);
use OpenAPI::Microservices::Utils::File qw(write_file);
use OpenAPI::Microservices::App::Types qw(
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

sub _fields {qw/name get_methods/}

sub _write_controller {
    my ( $self, $dir ) = @_;

    my $code       = '';
    my $model = $self->name;
    my $controller = $model;
    $controller =~ s/::Model::/::Controller::/;

    # the sort keeps the auto-generated code deterministic. We put short paths
    # first just because it's easier to read, but we break ties by sorting on
    # the guaranteed unique names
    my @methods = sort { length( $a->path ) <=> length( $b->path ) || $a->name cmp $b->name } @{ $self->get_methods };
    foreach my $method (@methods) {
        my $http_method = $method->http_method;
        my $path        = $method->path;
        my $name        = $method->name;
        $code .= "        { path => '$path', http_method => '$http_method', controller => '$controller',  action => '$name' },\n";
    }
    chomp($code);
    $code = tidy_code(<<"END");
sub routes {
    return (
$code
    );
}
END
    my $rewrite = OpenAPI::Microservices::Utils::ReWrite->new( new_text => $code, identifier => $controller );
    my ( $path, $filename) = $self->_get_path_and_file($dir, $controller);
    my $controller_code = template(
        'controller',
        {
            code_for_routes => $rewrite->rewritten,
            methods         => \@methods,
            package         => $controller,
            model           => $model,
        }
    );
    write_file(
        path     => $path,
        file     => $filename,
        document => $controller_code,
        rewrite  => 1,
    );
}

sub write {
    my ( $self, $dir ) = @_;
    my ( $path, $filename) = $self->_get_path_and_file($dir, $self->name);
    my %fields = map { $_ => $self->$_ } $self->_fields;

    my $template = Template::Tiny->new;
    my $format   = $self->_template;
    $template->process( \$format, \%fields, \my $output );

    write_file(
        path      => $path,
        file      => $filename,
        document  => tidy_code( $output ),
        overwrite => 0,
    );
    $self->_write_controller($dir);
}

sub _get_path_and_file {
    my ( $self, $dir, $package_name ) = @_;

    my ( $base, $filename );
    if ( $package_name =~ /^(?<path>.*::)(?<file>.*)$/ ) {
        $base     = $+{path};
        $filename = $+{file};
        $base =~ s{::}{/}g;
    }
    else {
        croak("Bad package name: $package_name");
    }

    $filename .= ".pm";
    my $path = "$dir/lib/$base";
    return ( $path, $filename );
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
        description => NonEmptyStr,
    );
    my $arg_for = $check->(@_);

    my ( undef, $method_name, $args ) = resolve_method(
        $self->base,
        $arg_for->{http_method},
        $arg_for->{path},
    );

    if ( $self->has_method($method_name) ) {
        croak("Cannot re-add method '$arg_for->{method}'");
    }
    my $method = OpenAPI::Microservices::Builder::Method->new(
        package     => $self,
        name        => $method_name,
        path        => $arg_for->{path},
        http_method => $arg_for->{http_method},
        description => $arg_for->{description},
        arguments   => ( $args || [] )
    );
    $self->methods->{$method_name} = $method;
    return $method;
}

sub _template {
    return <<'END';
package [% name %];

use strict;
use warnings;
use OpenAPI::Microservices::Exceptions::HTTP::NotImplemented;

=head1 NAME

[% name %]

=head1 METHODS
[% FOREACH method IN get_methods %]
[% method.to_string %]
[% END %]

1;
END
}
1;
