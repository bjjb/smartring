# frozen_string_literal: true

module Smartling
  # Methods for the Smartling strings API
  module Strings
    def source_strings(project_id: @project_id, file_uri: nil, hashcodes: nil,
                       limit: nil, offset: nil)
      path = "/strings-api/v2/projects/#{project_id}/source-strings"
      query = {}
      query[:fileUri] = file_uri unless file_uri.nil?
      query[:stringHashcodes] = hashcodes unless hashcodes.nil?
      query[:limit] = Integer(limit) unless limit.nil?
      query[:offset] = Integer(offset) unless limit.nil?
      get(path, query: query)
    end

    def translations(project_id: @project_id, file_uri: nil, hashcodes: nil,
                     limit: nil, offset: nil, retrieval_type: nil,
                     target_locale_id: nil)
      path = "/strings-api/v2/projects/#{project_id}/translations"
      query = {}
      query[:fileUri] = file_uri unless file_uri.nil?
      query[:hashcodes] = hashcodes unless hashcodes.nil?
      query[:retrievalType] = retrieval_type unless retrieval_type.nil?
      query[:limit] = Integer(limit) unless limit.nil?
      query[:offset] = Integer(offset) unless limit.nil?
      query[:targetLocaleId] = target_locale_id unless target_locale_id.nil?
      get(path, query: query)
    end
  end
end
