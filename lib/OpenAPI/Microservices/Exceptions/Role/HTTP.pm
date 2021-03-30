package OpenAPI::Microservices::Exceptions::Role::HTTP;

# ABSTRACT: Base role for HTTP exceptions

use Moo::Role;
use OpenAPI::Microservices::Policy;
use OpenAPI::Microservices::Utils::Types qw(
  InstanceOf
  NonEmptyStr
);
use Devel::StackTrace;

requires qw(
  status_code
  message
);

has stacktrace => (
    is  => 'rwp',
    isa => InstanceOf ['Devel::StackTrace'],
);

has info => (
    is        => 'rwp',
    isa       => NonEmptyStr,
    predicate => 1,
);

sub throw {
    my ( $self, $info ) = @_;
    if ( not ref $self ) {
        $self = $self->new;

        # called as a class method. This is the first time this has been
        # thrown, so let's capture the stacktrace
        my $trace = Devel::StackTrace->new;
        $self->_set_stacktrace($trace);
    }

    # don't let a rethrow overwrite the original message
    if ( defined $info && !$self->has_info ) {
        $self->_set_info($info);
    }
    die $self;
}

sub to_string {
    my $self = shift;
    return sprintf( "%d %s\n\n%s", $self->status_code, $self->message, $self->stacktrace );
}

1;

