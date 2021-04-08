package Net::OpenAPI::Utils::Template;

# ABSTRACT: Code templates for Net::OpenAPI. Internal use only

=head1 WARNING

Don't just C<perldoc Net::OpenAPI::Utils::Template>. This module contains
templates and those templates often contain POD. POD parsers get confused and
show some very messed up POD. Use the source, Luke.

=cut

use Net::OpenAPI::Policy;
use Net::OpenAPI::Utils::Template::Tiny;
use Net::OpenAPI::Utils::ReWrite;
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
use base 'Exporter';

our @EXPORT_OK = qw(
  template
  write_template
);
use Const::Fast;
const my $REWRITE_BOUNDARY => '###« REWRITE BOUNDARY »###';

sub template {
    state $check = compile_named(
        name     => NonEmptySimpleStr,
        template => NonEmptyStr,
        data     => HashRef,
        tidy     => Optional [Bool],
    );
    my $arg_for = $check->(@_);

    my $template = Net::OpenAPI::Utils::Template::Tiny->new( name => $arg_for->{name} );

    # Generate template results into a variable
    my $output = '';
    $template->process(
        \$arg_for->{template},
        { %{ $arg_for->{data} }, rewrite_boundary => $REWRITE_BOUNDARY },
        \$output
    );
    my @chunks = split /$REWRITE_BOUNDARY/ => $output;
    if ( @chunks > 1 ) {
        unless ( @chunks == 3 ) {
            croak("Exactly two or zero rewrite boundaries allowed per template");
        }
        $chunks[1] = Net::OpenAPI::Utils::ReWrite->add_checksums( $chunks[1] );
        $output = join '' => @chunks;
    }

    if ( $arg_for->{tidy} ) {
        tidy_code($output);
    }

    return $output;
}

sub write_template {
    state $check = compile_named(
        template_name => NonEmptyStr,
        template_data => HashRef,
        path          => Directory,
        file          => NonEmptyStr,
        tidy          => Optional [Bool],
    );
    my $arg_for = $check->(@_);
    my $result  = template(
        $arg_for->{template_name},
        $arg_for->{template_data},
    );
    if ( $arg_for->{tidy} ) {
        tidy_code($result);
    }
    write_file(
        path     => $arg_for->{path},
        file     => $arg_for->{file},
        document => $result,
    );
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
See L<Net::OpenAPI::Utils::Template::Tiny> to understand template behavior.

1;
