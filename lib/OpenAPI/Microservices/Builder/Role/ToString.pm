package OpenAPI::Microservices::Builder::Role::ToString;

use Moo::Role;
use Template::Tiny;

requires qw(
  _template
  _fields
);

sub to_string {
    my $self   = shift;
    my %fields = map { $_ => $self->$_ } $self->_fields;

    my $template = Template::Tiny->new;
    my $format   = $self->_template;
    $template->process( \$format, \%fields, \my $output );
    return $output;
}

1;
