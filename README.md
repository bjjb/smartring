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

# Gets all Korean translations for the first file
file_uri = api.files.data.items.first.file_uri
api.translations(file_uri: file_uri, target_locale_id: 'ko')
```


Similar projects
----------------

- [smartling][1] is the official Ruby Smartling API.
- [smartling_api][2] is another wrapper that supports Project and File
  endpoints.

[![Build Status](http://img.shields.io/travis/bjjb/smartring.svg?style=flat-square)](https://travis-ci.org/bjjb/smartring)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8e717aedee6a4e956683/test_coverage)](https://codeclimate.com/github/bjjb/smartring/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/8e717aedee6a4e956683/maintainability)](https://codeclimate.com/github/bjjb/smartring/maintainability)
[![Dependency Status](http://img.shields.io/gemnasium/bjjb/smartring.svg?style=flat-square)](https://gemnasium.com/bjjb/smartring)
[![Gem Version](http://img.shields.io/gem/v/smartring.svg?style=flat-square)](https://rubygems.org/gems/smartring)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://bjjb.mit-license.org)

[1]: https://github.com/Smartling/api-sdk-ruby
[2]: https://github.com/redbubble/smartling_api
[API]: https://developer.smartling.com/v1.0/reference
