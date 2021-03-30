package TestsFor::OpenAPI::Microservices::Utils::ReWrite;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use OpenAPI::Microservices::Utils::ReWrite;
use OpenAPI::Microservices::Utils::Core ':all';

sub test_rewrite {
    my $test = shift;

    my $sample = <<'END';
It does me no injury for my neighbour to say there are 20 gods or no God. It neither picks my pocket nor breaks my leg.

— Thomas Jefferson
END

    ok my $rewrite = OpenAPI::Microservices::Utils::ReWrite->new( new_text => $sample ), 'We should be able to create a rewrite object without old text';

    my $expected = <<'END';
#<<<: do not touch any code between this and the end comment. Checksum: da4a8adfd9ad75321c955e0d226532a6

It does me no injury for my neighbour to say there are 20 gods or no God. It neither picks my pocket nor breaks my leg.

— Thomas Jefferson

#>>>: do not touch any code between this and the start comment. Checksum: da4a8adfd9ad75321c955e0d226532a6
END

    my $rewritten = $rewrite->rewritten;
    is $rewritten, $expected, '... and we should get our rewritten text back with start and end markers';

    $rewritten = "before\n\n$rewritten\nafter";

    my $new_text = <<'END';
Ces principes complètent ou précisent les valeurs exprimées par la devise de
la République française : « Liberté, égalité, fraternité ». Reconnue comme un
droit de l'homme par la Déclaration du 26 août 1789, la liberté est la valeur
fondamentale qui fait passer l'homme de la position de sujet au statut de
citoyen.
END

    ok $rewrite = OpenAPI::Microservices::Utils::ReWrite->new(
        old_text => $rewritten,
        new_text => $new_text,
    ), 'We should be able to rewrite the old text with new text, but leaving "outside" areas unchanged';

	$expected = <<'END';
before

#<<<: do not touch any code between this and the end comment. Checksum: 24e8541b178780253dcddeb0d5883e19

Ces principes complètent ou précisent les valeurs exprimées par la devise de
la République française : « Liberté, égalité, fraternité ». Reconnue comme un
droit de l'homme par la Déclaration du 26 août 1789, la liberté est la valeur
fondamentale qui fait passer l'homme de la position de sujet au statut de
citoyen.

#>>>: do not touch any code between this and the start comment. Checksum: 24e8541b178780253dcddeb0d5883e19

after
END
    $test->is_multiline_text( $rewrite->rewritten, $expected, '... and get our new text as expected');
}

1;
