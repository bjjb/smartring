# frozen_string_literal: true

require 'test_helper'
require 'smartling'

describe Smartling do
  it 'can be "instantiated"' do
    assert_instance_of Smartling::Client, Smartling.new
  end

  it 'handles things gracefully', :vcr do
    client = Smartling::Client.new
    assert_instance_of HipsterHash, client.files
    assert_instance_of HipsterHash, client.translations(file_uri: 'boo')
  end
end
