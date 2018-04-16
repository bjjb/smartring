# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require 'dotenv'
Dotenv.load '.env.local', '.env.test'

require 'vcr'
require 'cgi'
VCR.configure do |vcr|
  vcr.hook_into :webmock
  vcr.cassette_library_dir = 'test/cassettes'
  vcr.filter_sensitive_data('SMARTLING_PROJECT_ID') { ENV.fetch('SMARTLING_PROJECT_ID') }
  vcr.filter_sensitive_data('SMARTLING_USER_ID') { ENV.fetch('SMARTLING_USER_ID') }
  vcr.filter_sensitive_data('SMARTLING_USER_SECRET') { ENV.fetch('SMARTLING_USER_SECRET') }
end

require 'minitest-vcr'
MinitestVcr::Spec.configure!

require 'pry'
