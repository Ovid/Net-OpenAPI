package TestsFor::OpenAPI::Microservices::Utils::ReWrite;

# vim: textwidth=200

use Test::Class::Moose extends => 'Test::OpenAPI::Microservices';
use OpenAPI::Microservices::Utils::Core ':all';

sub test_rewrite {
    my $test = shift;

    my $sample = <<'END';
It does me no injury for my neighbour to say there are 20 gods or no God. It neither picks my pocket nor breaks my leg.

— Thomas Jefferson
END

    ok my $rewrite = $test->class_name->new( new_text => $sample, identifier => 'test' ), 'We should be able to create a rewrite object without old text';

    my $expected = <<'END';
#<<<: do not touch any code between this and the end comment. Checksum: da4a8adfd9ad75321c955e0d226532a6
It does me no injury for my neighbour to say there are 20 gods or no God. It neither picks my pocket nor breaks my leg.

— Thomas Jefferson
#>>>: do not touch any code between this and the start comment. Checksum: da4a8adfd9ad75321c955e0d226532a6
END

    # saving this for use later
    my $full_document_with_before_and_after_text = "this is before\n$expected\nthis is after";

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

    ok $rewrite = $test->class_name->new(
        old_text   => $rewritten,
        new_text   => $new_text,
        identifier => 'test',
      ),
      'We should be able to rewrite the old text with new text, but leaving "outside" areas unchanged';

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
    $rewritten = $rewrite->rewritten;
    $test->is_multiline_text( $rewritten, $expected, '... and get our new text as expected' );

    ok $rewrite = $test->class_name->new(
        old_text   => $rewritten,
        new_text   => $full_document_with_before_and_after_text,
        identifier => 'test',
      ),
      'We should be able to rewrite a document with a "full" new document, only extracting the rewrite portion of the new document.';
    $rewritten = $rewrite->rewritten;

    $expected = <<'END';
before

#<<<: do not touch any code between this and the end comment. Checksum: da4a8adfd9ad75321c955e0d226532a6
It does me no injury for my neighbour to say there are 20 gods or no God. It neither picks my pocket nor breaks my leg.

— Thomas Jefferson
#>>>: do not touch any code between this and the start comment. Checksum: da4a8adfd9ad75321c955e0d226532a6

after
END

    $test->is_multiline_text( $rewritten, $expected, '... and see only the part between checksums is replaced' );
}

1;
