package OpenAPI::Microservices::Utils::ReWrite;

use Moo;
use Mojo::File;
use OpenAPI::Microservices::Utils::Core qw(
  trim
);
use OpenAPI::Microservices::Utils::Types qw(
  Bool
  NonEmptyStr
);
use OpenAPI::Microservices::Policy;
use Digest::MD5 'md5_hex';

sub _start_marker_format {'#<<<: do not touch any code between this and the end comment. Checksum: %s'}
sub _end_marker_format   {'#>>>: do not touch any code between this and the start comment. Checksum: %s'}

has old_text => (
    is        => 'ro',
    isa       => NonEmptyStr,
    predicate => 1,
);

has new_text => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

has overwrite => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

has rewritten => (
    is  => 'rwp',
    isa => NonEmptyStr,
);

sub BUILD {
    my $self = shift;
    if ( $self->has_old_text ) {
        $self->_rewrite;
    }
    else {
        $self->_set_rewritten( $self->add_checksums( $self->new_text ) );
    }
}

sub _rewrite {
    my ($self) = @_;

    my ( $before, $after ) = $self->_extract_before_and_after;

    my $body = trim( $self->add_checksums( $self->new_text ) );
    $self->_set_rewritten("$before$body$after");

    END;
}

sub _extract_before_and_after {
    my ( $self, $text ) = @_;
    $text //= $self->old_text;

    my $digest_start_re = qr/(?<digest_start>[0-9a-f]{32})/;
    my $digest_end_re   = qr/(?<digest_end>[0-9a-f]{32})/;
    my $start_marker_re = sprintf $self->_start_marker_format => $digest_start_re;
    my $end_marker_re   = sprintf $self->_end_marker_format   => $digest_end_re;

    # don't use the /x modifier to make this prettier unless you call
    # quotemeta on the start and end markers
    my $extract_re = qr/^(?<before>.*?)$start_marker_re(?<body>.*?)$end_marker_re(?<after>.*?)$/s;

    if ( $text !~ $extract_re ) {
        croak("Could not find start and end markers in text.");
    }
    my $digest_start = $+{digest_start};
    my $digest_end   = $+{digest_end};

    unless ( $digest_start eq $digest_end ) {
        croak("Start digest ($digest_start) does not match end digest ($digest_end)");
    }

    if ( !$self->overwrite && $digest_start ne $self->_get_checksum( $+{body} ) ) {
        croak("Checksum ($digest_start) did not match text. Set 'overwrite' to true to ignore this.");
    }
    my $before = $+{before} // '';
    my $after  = $+{after}  // '';
    return ( $before, $after );
}

sub _get_checksum {
    my ( $self, $text ) = @_;
    return md5_hex( trim($text) );
}

=head2 C<add_checksums($text)>

    $text = $self->add_checksums($text);

Adds before/after checksum markers to C<$text>.

=cut

sub add_checksums {
    my ( $self, $text ) = @_;
    my $checksum = $self->_get_checksum($text);

    my $start = sprintf $self->_start_marker_format => $checksum;
    my $end   = sprintf $self->_end_marker_format   => $checksum;

    return <<"END";
$start

$text
$end
END
}

1;
