# frozen_string_literal: true

require 'test_helper'
require 'smartling/client'

describe Smartling::Client, :vcr do
  let(:options) { {} }
  let(:client) { Smartling::Client.new(options) }

  it('knows context') { assert client.is_a?(Smartling::Contexts) }
  it('knows about files') { assert client.is_a?(Smartling::Files) }
  it('knows about strings') { assert client.is_a?(Smartling::Strings) }
  it('knows about jobs') { assert client.is_a?(Smartling::Jobs) }
  it('knows how to authenticate') { assert client.is_a?(Smartling::Auth) }

  it 'can be created with options' do
    c = Smartling::Client.new(project_id: 3)
    refute_nil c.user_id
    refute_nil c.user_secret
    assert_equal 3, c.project_id
  end

  it 'is cool with bullshit' do
    path = '/no/such/path'
    assert_raises { Smartling::Client.new.get(path) }
  end

  it 'explains when credentials are borked' do
    path = '/auth-api/v2/authorize'
    assert_raises do
      Smartling::Client.new(user_id: 'no', user_secret: 'way').get(path)
    end
  end
end
