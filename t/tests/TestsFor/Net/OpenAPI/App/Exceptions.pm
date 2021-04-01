package TestsFor::Net::OpenAPI::App::Exceptions;
#
# vim: textwidth=200

use Test::Class::Moose extends => 'Test::Net::OpenAPI';
use Net::OpenAPI::App::Exceptions qw(throw);

sub test_exceptions {
    my $test = shift;

    throws_ok { throw(404) }
    'Net::OpenAPI::Exceptions::HTTP::NotFound',
      'We should be able to throw an exception by its number';
    throws_ok { throw('Forbidden') }
    'Net::OpenAPI::Exceptions::HTTP::Forbidden',
      '... or by its short name';
    throws_ok { throw( InternalServerError => 'I messed up!' ) }
    'Net::OpenAPI::Exceptions::HTTP::InternalServerError',
      '... and we should be able to supply an optional message';
    is $@->info, 'I messed up!', '... and have it passed to the exception';
}

__PACKAGE__->meta->make_immutable;
