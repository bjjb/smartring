# frozen_string_literal: true

require 'test_helper'
require 'hipsterhash'
require 'httmultiparty'
require 'smartling/client'

describe Smartling::Auth do
  describe 'authenticate (first time)' do
    it 'POSTs to the authentication endpoint', :vcr do
      client = Smartling::Client.new
      client.authenticate!
    end
  end

  describe 'authenticate (twice)' do
    it 'POSTs to the authentication endpoint', :vcr do
      client = Smartling::Client.new
      client.authenticate!
      client.refresh_token!
      client.authenticate!
    end
  end
end
