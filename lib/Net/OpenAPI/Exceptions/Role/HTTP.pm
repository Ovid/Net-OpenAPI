package Net::OpenAPI::Exceptions::Role::HTTP;

# ABSTRACT: Interface for HTTP exceptions

use Moo::Role;

requires qw(
  status_code
  message
  throw
  to_string
);

1;

