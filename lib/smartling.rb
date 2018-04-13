# frozen_string_literal: true

require 'smartling/client'

# Smartling contains a client and helpers for working with the Smartling
# files, contexts, strings and authentication API
module Smartling
  class << self
    # Gets a new Client
    def new(*args)
      Client.new(*args)
    end
  end
end
