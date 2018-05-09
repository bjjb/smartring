# frozen_string_literal: true

require 'json'
require 'smartling/auth'
require 'smartling/files'
require 'smartling/contexts'
require 'smartling/strings'
require 'smartling/jobs'
require 'smartling/verbs'
require 'hipsterhash'
require 'forwardable'

module Smartling
  # A fairly generic Smartling REST API client.
  class Client
    include HTTMultiParty
    include Auth
    include Files
    include Strings
    include Jobs
    include Contexts
    include Verbs

    attr_accessor :project_id

    base_uri  'https://api.smartling.com'
    headers   'Accept' => 'application/json'
    raise_on  [404, 401, 500]

    def initialize(user_id:     ENV.fetch('SMARTLING_USER_ID'),
                   user_secret: ENV.fetch('SMARTLING_USER_SECRET'),
                   project_id:  ENV.fetch('SMARTLING_PROJECT_ID', nil))
      @user_id = user_id
      @user_secret = user_secret
      @project_id = project_id
    end
  end
end
