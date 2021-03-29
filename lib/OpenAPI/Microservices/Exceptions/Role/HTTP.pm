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

has additional_message => (
    is        => 'rwp',
    isa       => NonEmptyStr,
    predicate => 1,
);

sub throw {
    my ( $self, $additional_message ) = @_;
    if ( not ref $self ) {
        $self = $self->new;

        # called as a class method. This is the first time this has been
        # thrown, so let's capture the stacktrace
        my $trace = Devel::StackTrace->new;
        $self->_set_stacktrace($trace);
    }

    # don't let a rethrow overwrite the original message
    if ( defined $additional_message && !$self->has_additional_message ) {
        $self->_set_additional_message($additional_message);
    }
    die $self;
}

sub to_string {
    my $self = shift;
    return sprintf( "%s\n\n%s", $self->status, $self->stacktrace->as_string, );
}

sub status {
    my $self = shift;
    return $self->has_additional_message
      ? sprintf( "%d %s (%s)", $self->status_code, $self->message, $self->additional_message )
      : sprintf( "%d %s", $self->status_code, $self->message );
}

1;

