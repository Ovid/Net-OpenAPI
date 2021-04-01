package Net::OpenAPI::Builder::Package;

use Moo;

use Net::OpenAPI::Policy;
use Net::OpenAPI::Builder::Method;
use Net::OpenAPI::Utils::ReWrite;
use Net::OpenAPI::Utils::Core qw(resolve_method resolve_package tidy_code);
use Net::OpenAPI::Utils::Template qw(template);
use Net::OpenAPI::Utils::File qw(write_file);
use Net::OpenAPI::App::Types qw(
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

has controller_name => (
    is       => 'lazy',
    isa      => PackageName,
    builder => sub {
        my $self = shift;
        return join '::' => $self->base, 'Controller', $self->root;
    },
);

has model_name => (
    is       => 'lazy',
    isa      => PackageName,
    builder => sub {
        my $self = shift;
        return join '::' => $self->base, 'Model', $self->root;
    },
);

has base => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has root => (
    is       => 'ro',
    isa      => PackageName,
    required => 1,
);

has methods => (
    is       => 'ro',
    isa      => HashRef [ InstanceOf ['Net::OpenAPI::Builder::Method'] ],
    default  => sub { {} },
    init_arg => undef,
);

sub get_methods { return [ values %{ $_[0]->methods } ] }

sub add_method {
    my $self = shift;
    state $check = compile_named(
        http_method => HTTPMethod,
        path        => NonEmptyStr,
        description => NonEmptyStr,
    );
    my $arg_for = $check->(@_);

    my ( $method_name, $args ) = resolve_method(
        $arg_for->{http_method},
        $arg_for->{path},
    );

    if ( $self->_has_method($method_name) ) {
        my $base = $self->base;
        my $root = $self->root;
        croak("Cannot re-add action '$arg_for->{http_method} $arg_for->{path}' to ($base $root)");
    }
    my $method = Net::OpenAPI::Builder::Method->new(
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

sub write {
    my ( $self, $dir ) = @_;
    $self->_write_controller($dir);
    $self->_write_model($dir);
}

sub _write_controller {
    my ( $self, $dir ) = @_;

    my ( $code, $path, $filename ) = $self->_get_controller_code($dir);
    write_file(
        path     => $path,
        file     => $filename,
        document => tidy_code($code),
        rewrite  => 1,
    );
}

sub _write_model {
    my ( $self, $dir ) = @_;

    my ( $code, $path, $filename ) = $self->_get_model_code($dir);
    write_file(
        path     => $path,
        file     => $filename,
        document => tidy_code($code),
    );
}

sub _get_controller_code {
    my ( $self, $dir ) = @_;

    my $code       = '';
    my $model      = $self->model_name;
    my $controller = $self->controller_name;

    # the sort keeps the auto-generated code deterministic. We put short paths
    # first just because it's easier to read, but we break ties by sorting on
    # the guaranteed unique names
    my @methods = sort { length( $a->path ) <=> length( $b->path ) || $a->name cmp $b->name } @{ $self->get_methods };
    foreach my $method (@methods) {
        my $http_method = $method->http_method;
        my $path        = $method->path;
        my $name        = $method->name;
        $code .= "        { path => '$path', http_method => '$http_method', dispatch_to => '$model',  action => '$name' },\n";
    }
    chomp($code);
    $code = <<"END";
sub routes {
    return (
$code
    );
}
END
    $code = tidy_code($code);
    my $rewrite = Net::OpenAPI::Utils::ReWrite->new( new_text => $code, identifier => $controller );
    my ( $path, $filename ) = $self->_get_path_and_file( $dir, $controller );
    my $controller_code = template(
        'controller',
        {
            code_for_routes => $rewrite->rewritten,
            methods         => \@methods,
            package         => $controller,
            model           => $model,
        }
    );
    return ( $controller_code, $path, $filename );
}

sub _get_model_code {
    my ( $self, $dir ) = @_;
    my $model_name = $self->model_name;
    my ( $path, $filename ) = $self->_get_path_and_file( $dir, $model_name );

    my $code = <<'END';
# This space is reserved for future code.
END

    my $rewrite = Net::OpenAPI::Utils::ReWrite->new( new_text => $code, identifier => $model_name );

    my $model_code = template(
        'model',
        {
            name        => $model_name,
            get_methods => $self->get_methods,
            reserved    => $rewrite->rewritten,
        }
    );

    return ( $model_code, $path, $filename );
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

sub _has_method {
    my ( $self, $method_name ) = @_;
    state $check = compile(MethodName);
    ($method_name) = $check->($method_name);
    return exists $self->methods->{$method_name};
}

1;
