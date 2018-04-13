A Ruby library for the Smartling [API][] (v2)

Installation
------------

    gem install smartring

Or to include it in your Bundler project, add this to your Gemfile:

    gem 'smartring'

Usage
-----

To get started with the CLI, use

    smartring -h

Here's an example of using it in a Ruby library:

```ruby
require 'smartring'

# Upload a new file for translation
file = Smartring::Files::JSON.new()
api = Smartring.new(user_id: USER_ID, user_secret: USER_SECRET)
api.files(project_id: PROJECT_ID).each do |file|
  puts file.file_uri
end

# Gets all Korean
api.strings(file_uri: api.files.first.file_uri).each do |file|
  
```


Similar projects
----------------

- [smartling][1] is the official Ruby Smartling API.
- [smartling_api][2] is another wrapper that supports Project and File
  endpoints.

[1]: https://github.com/Smartling/api-sdk-ruby
[2]: https://github.com/redbubble/smartling_api
[API]: https://developer.smartling.com/v1.0/reference
