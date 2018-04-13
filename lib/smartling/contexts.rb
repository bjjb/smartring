# frozen_string_literal: true

module Smartling
  # Methods for dealing wth the Smartling Contexts API
  module Contexts
    def contexts(project_id: @project_id, name_filter: nil, offset: nil,
                 type: nil)
      path = "/context-api/v2/projects/#{project_id}/contexts"
      query = {}
      query[:nameFilter] = name_filter unless name_filter.nil?
      query[:offset] = Integer(offset) unless offset.nil?
      query[:type] = type.to_s.upcase unless type.nil?
      get(path, query: query)
    end

    def context(project_id: @project_id, context_uid:)
      path = "/context-api/v2/projects/#{project_id}/contexts/#{context_uid}"
      get(path)
    end

    # Uploads a new context. Content must quack like an UploadIO.
    def upload_context(project_id: @project_id, content:, name: nil)
      path = "/context-api/v2/projects/#{project_id}/contexts"
      raise(InvalidContent, content) unless Contexts.valid_content?(content)
      body = { content: content }
      body[:name] = name unless name.nil?
      post(path, body: body)
    end

    # Uploads a new context. Content must quack like an UploadIO.
    def upload_context_and_match(project_id: @project_id, content:,
                                 match_params: nil, name: nil)
      path = "/context-api/v2/projects/#{project_id}/contexts"
      path += '/upload-and-match-async'
      raise(InvalidContent, content) unless Contexts.valid_content?(content)
      body = { content: content }
      body[:name] = name unless name.nil?
      body[:matchParams] = match_params unless match_params.nil?
      post(path, body: body)
    end

    def download_context(project_id: @project_id, context_uid:)
      path = "/context-api/v2/projects/#{project_id}/contexts"
      path += "/#{context_uid}/content"
      get(path)
    end

    def delete_context(project_id: @project_id, context_uid:)
      path = "/context-api/v2/projects/#{project_id}/contexts/#{context_uid}"
      delete(path)
    end

    # POSTs to the /match/async endpoint
    def match_context(project_id: @project_id, context_uid:, hashcodes: [])
      path = "/context-api/v2/projects/#{project_id}/contexts/#{context_uid}"
      path += '/match/async'
      query = { stringHashcodes: hashcodes }.to_json
      headers = { 'Content-Type' => 'application/json' }
      post(path, query: query, headers: headers)
    end

    # GETs the results of an async match
    def context_matches(project_id: @project_id, match_id:)
      path = "/context-api/v2/projects/#{project_id}/match/#{match_id}"
      get(path)
    end

    InvalidContent = Class.new(ArgumentError)

    def self.valid_content?(content)
      %i[read content_type original_filename].all? do |required_method|
        content.respond_to?(required_method)
      end
    end
  end
end
