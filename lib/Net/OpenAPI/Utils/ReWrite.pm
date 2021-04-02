package Net::OpenAPI::Utils::ReWrite;

# ABSTRACT: Safely rewrite parts of documents

use Moo;
use Mojo::File;
use Net::OpenAPI::Utils::Core qw(
  trim
);
use Net::OpenAPI::App::Types qw(
  Bool
  NonEmptyStr
);
use Net::OpenAPI::Policy;
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

has identifier => (
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

    my $extract_re = $self->_regex_to_match_rewritten_document;

    my $replacement = $self->new_text;
    if ( $replacement =~ $extract_re ) {

        # we have a full document with start and end rewrite tags, so let's
        # just extract that
        $replacement = $self->_extract_body;
    }

    my $body = trim( $self->add_checksums($replacement) );
    my ( $before, $after ) = $self->_extract_before_and_after;
    $self->_set_rewritten("$before$body$after");
}

sub _extract_before_and_after {
    my ( $self, $text ) = @_;
    $text //= $self->old_text;

    my $extract_re = $self->_regex_to_match_rewritten_document;
    my $identifier = $self->identifier;
    if ( $text !~ $extract_re ) {
        croak("Could not find start and end markers in text for $identifier");
    }
    my $digest_start = $+{digest_start};
    my $digest_end   = $+{digest_end};

    unless ( $digest_start eq $digest_end ) {
        croak("Start digest ($digest_start) does not match end digest ($digest_end) for $identifier");
    }

    if ( !$self->overwrite && $digest_start ne $self->_get_checksum( $+{body} ) ) {
        croak("Checksum ($digest_start) did not match text. Set 'overwrite' to true to ignore this for $identifier");
    }
    my $before = $+{before} // '';
    my $after  = $+{after}  // '';
    return ( $before, $after );
}

sub _extract_body {
    my ( $self, $text ) = @_;
    $text //= $self->new_text;

    my $extract_re = $self->_regex_to_match_rewritten_document;
    my $identifier = $self->identifier;
    if ( $text !~ $extract_re ) {
        croak("Could not find start and end markers in text for $identifier");
    }
    my $digest_start = $+{digest_start};
    my $digest_end   = $+{digest_end};

    unless ( $digest_start eq $digest_end ) {
        croak("Start digest ($digest_start) does not match end digest ($digest_end) for $identifier");
    }

    return trim( $+{body} );
}

#
# Internal method. Returns a regex that can use used to match a "rewritten"
# document. If the regex matches, we have a rewritten document. You can
# extract parts via:
#
#     my $regex = $self->_regex_to_match_rewritten_document;
#     if ( $document =~ $regex ) {
#         my $before       = $+{before};
#         my $digest_start = $+{digest_start};    # checksum from start tag
#         my $body         = $+{body};            # between start and end tags
#         my $digest_end   = $+{digest_end};      # checksum from end tag
#         my $after        = $+{after};
#     }
#
# This is not an attribute because we need to be able to call it as a class
# method
#

sub _regex_to_match_rewritten_document {
    my $class = shift;

    my $digest_start_re = qr/(?<digest_start>[0-9a-f]{32})/;
    my $digest_end_re   = qr/(?<digest_end>[0-9a-f]{32})/;
    my $start_marker_re = sprintf $class->_start_marker_format => $digest_start_re;
    my $end_marker_re   = sprintf $class->_end_marker_format => $digest_end_re;

    # don't use the /x modifier to make this prettier unless you call
    # quotemeta on the start and end markers
    return qr/^(?<before>.*?)$start_marker_re(?<body>.*?)$end_marker_re(?<after>.*?)$/s;
}

sub _get_checksum {
    my ( $class, $text ) = @_;
    return md5_hex( trim($text) );
}

=head2 C<add_checksums>

    my $checksummed_text = Net::OpenAPI::Utils::ReWrite->add_checksums($text);

This is a class method which allows you to add the start and end checksums to
any arbitrary piece of text.

=cut

sub add_checksums {
    my ( $class, $text ) = @_;
	$text = trim($text);
    my $checksum = $class->_get_checksum($text);

    my $start = sprintf $class->_start_marker_format => $checksum;
    my $end   = sprintf $class->_end_marker_format   => $checksum;

    return <<"END";
$start
$text
$end
END
}

1;

__END__

=head1 SYNOPSIS

    my $rewrite = Net::OpenAPI::Utils::ReWrite->new(
        new_text => $text,
    );
    say $rewrite->rewritten;

    my $rewrite = Net::OpenAPI::Utils::ReWrite->new(
        old_text => $old_text,
        new_text => $new_text,
    );
    say $rewrite->rewritten;

=head1 DESCRIPTION

This module allows you to do a safe partial rewrite of documents. If you're
familiar with L<DBIx::Class::Schema::Loader>, you probably know the basic
concept.

Note that this code is designed for Perl documents and is not very
configurable.

=head1 MODES

There are two modes. Creating and rewriting.

=head2 Creating

    my $rewrite = Net::OpenAPI::Utils::ReWrite->new(
        new_text => $text,
    );
    say $rewrite->rewritten;

If you create an instance with C<new_text> but not old text, this will wrap
the new text in start and end tags that "protect" the document if you rewrite
it:


    my $rewrite = $test->class_name->new( new_text => 'Howdy, neighbor!' );
    say $rewrite->rewritten;

	# output:

    #<<<: do not touch any code between this and the end comment. Checksum: de563faeaa6b97eb6323abec39dc00c3
    Howdy, neighbor!
    #>>>: do not touch any code between this and the start comment. Checksum: de563faeaa6b97eb6323abec39dc00c3

You can then take the marked up document and insert it into another Perl
document and use the rewrite mode to safely rewrite the code between the start
and end documents.  The rest of the document will be ignored.

Note that leading and trailing comments start with C<< #<<< >> and C<< #>>> >>
respectively. Those are special comments which tell L<Perl::Tidy> to ignore
what ever is between them. Thus, you can safely tidy code written with this.

The start and end checksums are the same and are the checksum of the text
between the comments. Leading and trailing whitespace is ignored (in fact,
it's trimmed).

=head2

Given a document created with the "Creating" mode, you can then take the marked
up document and insert it into another Perl document and use the rewrite mode
to safely rewrite the code between the start and end documents.  The rest of
the document will be ignored.

    my $rewrite = Net::OpenAPI::Utils::ReWrite->new(
        old_text => $old_text,
        new_text => $new_text,
    );
    say $rewrite->rewritten;

In the above, assuming that C<$old_text> is a rewritable document, the C<$new_text>
will replace the rewritable section of the C<$old_text>, leaving the rest unchanged.

However, if C<$new_text> is I<also> a rewritable document, then the rewritable
portion of the C<$new_text> will be extract and used to replace the rewritable
portion of the C<$old_text>.
