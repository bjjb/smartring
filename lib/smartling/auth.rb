# frozen_string_literal: true

require 'httmultiparty'
require 'hipsterhash'

module Smartling
  # Methods for authenticating a Smartling user with the API.
  module Auth
    attr_reader :user_id, :user_secret, :access_token, :refresh_token

    def authenticate
      refresh_token! if access_token&.expired? && refresh_token&.valid?
      authenticate! unless access_token&.valid?
      token = access_token.to_s
      return token unless block_given?
      yield token
    end

    public

    def refresh_token!
      path = '/auth-api/v2/authenticate/refresh'
      headers = { 'Content-Type' => 'application/json' }
      payload = { refreshToken: refresh_token.to_s }.to_json
      resp = self.class.post(path, headers: headers, query: payload)
      resp = HipsterHash[resp.parsed_response].response
      raise(Failed, resp) unless resp.code == 'SUCCESS'
      self.tokens = resp.data
      true
    end

    def authenticate!
      path = '/auth-api/v2/authenticate'
      payload = { userIdentifier: user_id, userSecret: user_secret }.to_json
      headers = { 'Content-Type' => 'application/json' }
      resp = self.class.post(path, headers: headers, body: payload)
      resp = HipsterHash[resp.parsed_response].response
      raise(Failed, resp) unless resp.code == 'SUCCESS'
      self.tokens = resp.data
      true
    end

    def tokens=(data)
      @access_token = Token.new(data.accessToken, data.expiresIn)
      @refresh_token = Token.new(data.refreshToken, data.refreshExpiresIn)
    end

    Token = Class.new do
      def initialize(token, expires_in)
        @token = token
        @expires_at = Time.now + expires_in
      end
      define_method(:expired?) { @expires_at < Time.now }
      define_method(:valid?) { !expired? }
      define_method(:to_s) { @token.to_s }
    end

    Error = Class.new(Exception)
    Failed = Class.new(Error)
  end
end
