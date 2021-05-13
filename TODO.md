# Critical:

* Use JSON::Validator::Schema::OpenAPIv3's ability to validate input and output

# Important

* Support OpenAPI v2
* Versioning (app versioning)
* Data-driven testing
* Allow names to be remapped (similar to Schema loader)
* Text::UniDecode to allow for non-ascii routes
* Map OpenAPI types to Net::OpenAPI::App::Types
* Do we need to convert OpenAPI regexes to Perl's regexes?

# Maybe out of scope

* XML: https://swagger.io/docs/specification/data-models/representing-xml/
* App and API keys
* API dependencies
    - Api registry/repository
* API Gateway handling (?)
    - authentication
    - control
    - load distribution
    - caching
    - manipulation responses,
    - throttling
