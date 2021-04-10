package Test::Net::OpenAPI::Role::Tempdir;

# ABSTRACT: Tempdir role for tests

use Moose::Role;

use Net::OpenAPI::Policy;
use Net::OpenAPI::App::Types qw(
  Directory
);
use File::Temp ();
use File::Path qw(rmtree);

has tempdir => (
    is        => 'ro',
    isa       => Directory,
    lazy      => 1,
    predicate => 'has_tempdir',
    clearer   => '_reset_tempdir',
    builder   => '_build_tempdir',
);

sub _build_tempdir {
    return File::Temp::tempdir('/tmp/net_open_api_XXXXXXX');
}

sub remove_tempdir {
    my $test = shift;
    return unless $test->has_tempdir;
    $test->_reset_tempdir;
    rmtree( $test->tempdir );
}

before test_setup => sub {
    my $test = shift;
    $test->remove_tempdir;
};

after test_shutdown => sub {
    my $test = shift;
    $test->remove_tempdir;
};

1;

__END__

=head1 SYNOPSIS

    package TestsFor::Net::OpenAPI::Builder;

    use Test::Class::Moose extends => 'Test::Net::OpenAPI';
    with 'Test::Net::OpenAPI::Role::Tempdir';

    sub test_basics {
        my $test = shift;
        my $tempdir = $test->tempdir;

        ... write tests
    }

    __PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

Provides "per test method" temp directories that are guaranteed to be cleaned up.

=head1 METHODS

=head2 C<tempdir>

    my $tempdir = $test->tempdir;

Returns a new temp directory. Always returns the same temp directory for a
given method, unless C<remove_tempdir> is called, in which case a new temp
directory is generated:

    my $tempdir = $test->tempdir;
    $test->remove_tempdir;    # $tempdir no longer exists
    $tempdir = $test->tempdir;    # new temp directory

=head2 C<remove_tempdir>

    $test->remove_tempdir;

Removes current temp directory (if any) returned by C<< $test->tempdir >>.
