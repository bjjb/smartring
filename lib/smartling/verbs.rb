
# frozen_string_literal: true

module Smartling
  module Verbs
    %i[get put post patch delete].each do |verb|
      define_method(verb) do |path, options = {}|
        authenticate do |token|
          (options[:headers] ||= {})[:Authorization] = "Bearer #{token}"
          resp = self.class.send(verb, path, options).parsed_response
          return resp unless resp.is_a?(Hash)
          HipsterHash[resp].response
        end
      end
    end
  end
end
