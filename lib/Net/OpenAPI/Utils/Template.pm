package Net::OpenAPI::Utils::Template;

# ABSTRACT: Code templates for Net::OpenAPI. Internal use only

=head1 WARNING

Don't just C<perldoc Net::OpenAPI::Utils::Template>. This module contains
templates and those templates often contain POD. POD parsers get confused and
show some very messed up POD. Use the source, Luke.

=cut

use Net::OpenAPI::Policy;
use Template::Tiny::Strict;
use Net::OpenAPI::App::Types qw(
  compile_named
  NonEmptyStr
  HashRef
  Directory
  Bool
  Optional
  NonEmptySimpleStr
);
use Net::OpenAPI::Utils::Core qw(
  tidy_code
);
use Net::OpenAPI::Utils::File qw(write_file);
use CodeGen::Protection qw(create_protected_code);
use base 'Exporter';

our @EXPORT_OK = qw(
  template
);
use Const::Fast;
const my $REWRITE_BOUNDARY => '###« REWRITE BOUNDARY »###';

our $VERSION = '0.01';

sub template {
    state $check = compile_named(
        name     => NonEmptySimpleStr,
        template => NonEmptyStr,
        data     => HashRef,
        tidy     => Optional [Bool],
    );
    my $arg_for = $check->(@_);

    my $template = Template::Tiny::Strict->new( name => $arg_for->{name}, forbid_undef => 1, forbid_unused => 1 );

    # FIXME
    # We shouldn't be using a heuristic check here, but since we control the
    # templates, this isn't too bad
    my @rewrite_boundary = $arg_for->{template} =~ /\brewrite_boundary\b/ ? ( rewrite_boundary => $REWRITE_BOUNDARY ) : ();

    # Generate template results into a variable
    my $output = '';
    $template->process(
        \$arg_for->{template},
        { %{ $arg_for->{data} }, @rewrite_boundary },
        \$output
    );
    my @chunks = split /$REWRITE_BOUNDARY/ => $output;
    if ( @chunks > 1 ) {
        unless ( @chunks == 3 ) {
            croak("Exactly two or zero rewrite boundaries allowed per template");
        }
        $chunks[1] = create_protected_code( type => 'Perl', protected_code => $chunks[1], tidy => 1, name => $arg_for->{name} );
        $output = join '' => @chunks;
    }

    if ( $arg_for->{tidy} ) {
        tidy_code($output);
    }

    return $output;
}

1;

=head1 SYNOPSIS

    use Net::OpenAPI::Utils::Template qw(template);
    print template(
        'app',
        {
            package     => 'My::Package',
            models      => [ 'My::App::OpenAPI::Model', 'My::App::OpenAPI::Model2' ],
            controllers => [ 'My::App::OpenAPI::Controller', 'My::App::OpenAPI::Controller2' ],
            base        => 'My::App::OpenAPI',
        }
    );

=head1 DESCRIPTION

We use these templates to autogenerate our code. You must pass in the data required.
See L<Template::Tiny::Strict> to understand template behavior.

1;
