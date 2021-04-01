package Test::Net::OpenAPI::Exceptions::Role::HTTP;

use Moose::Role;
use Test::Most;

requires qw(
  status_code
  message
);

sub test_exception {
    my $test = shift;

    throws_ok { $test->class_name->throw('This is an extra message') } $test->class_name,
      "We should be able to throw an instance of " . $test->class_name;
    my $exception = $@;

    my $code    = $test->status_code;
    my $message = $test->message;

    is $exception->status_code, $code,    "We should get the correct status code: $code";
    is $exception->message,     $message, "We should get the correct message: $message";

    like "$exception", qr/Trace begun at/, 'Stringifying the exception should include a stack trace';
    my $expected = "$exception";
    is $exception->to_string, $expected, '... and should be the same as calling the "to_string" method';

    my $trace = $exception->stacktrace;
    isa_ok $trace, 'Devel::StackTrace', 'We should be able to ask for the stack trace directly';

    throws_ok { $exception->throw } $test->class_name,
      "We should be able to rethrow our exception" . $test->class_name;
    is $exception->to_string, $expected, '... and our stack trace should be unchanged';
}

1;
