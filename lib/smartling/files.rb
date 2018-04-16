# frozen_string_literal: true

require 'time'
require 'net/http/post/multipart'

module Smartling
  # Methods for using the Smartling files API
  module Files
    def files(project_id: @project_id)
      path = "/files-api/v2/projects/#{project_id}/files/list"
      get(path)
    end

    def file(project_id: @project_id, file_uri:, locale: nil)
      path = ["/files-api/v2/projects/#{project_id}"]
      path << "locales/#{locale}" unless locale.nil?
      path << 'file/status'
      path = path.join('/')
      get(path, query: { fileUri: file_uri })
    end

    def delete_file(project_id: @project_id, file_uri:)
      path = "/files-api/v2/projects/#{project_id}/file/delete"
      post(path, body: { fileUri: file_uri })
    end

    def upload_file(project_id: @project_id, file:, file_uri:, file_type:,
                    callback: nil, authorize: nil, locales_to_authorize: nil,
                    smartling: {})
      raise(InvalidFile, file) unless Files.valid_file?(file)
      path = "/files-api/v2/projects/#{project_id}/file"
      body = { file: file, fileUri: file_uri, fileType: file_type }
      body[:authorize] = authorize unless authorize.nil?
      body[:callback] = callback unless callback.nil?
      unless locales_to_authorize.nil?
        body[:localeIdsToAuthorize] = locales_to_authorize
      end
      smartling.each { |k, v| body["smartling.#{k}"] = v }
      post(path, body: body)
    end

    InvalidFile = Class.new(ArgumentError)

    def self.valid_file?(content)
      %i[read content_type original_filename].all? do |required_method|
        content.respond_to?(required_method)
      end
    end
  end
end
