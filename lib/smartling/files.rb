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

    def file_types(project_id: @project_id)
      path = "/files-api/v2/projects/#{project_id}/file-types"
      get(path)
    end

    def file_status(project_id: @project_id, file_uri:, locale: nil)
      path = ["/files-api/v2/projects/#{project_id}"]
      path << "locales/#{locale}" unless locale.nil?
      path << 'file/status'
      path = path.join('/')
      get(path, query: { fileUri: file_uri })
    end

    alias file file_status

    def download_original_file(project_id: @project_id, file_uri:)
      path = "/files-api/v2/projects/#{project_id}/file"
      get(path, query: { fileUri: file_uri })
    end

    def download_translated_file(project_id: @project_id, file_uri:, locale:,
                                retrieval_type: nil, include_original: nil)
      path = "/files-api/v2/projects/#{project_id}/locales/#{locale}/file"
      query = { fileUri: file_uri }
      query[:retrievalType] = retrieval_type unless retrieval_type.nil?
      query[:includeOriginalStrings] = true if include_original
      get(path, query: query)
    end

    def download_file(project_id: @project_id, file_uri:, locale: nil)
      return download_translated_file(project_id: project_id,
                                      file_uri: file_uri,
                                      locale: locale) unless locale.nil?
      download_original_file(project_id: project_id, file_uri: file_uri)
    end

    def delete_file(project_id: @project_id, file_uri:)
      path = "/files-api/v2/projects/#{project_id}/file/delete"
      post(path, body: { fileUri: file_uri })
    end

    def rename_file(project_id: @project_id, file_uri:, new_file_uri:)
      path = "/files-api/v2/projects/#{project_id}/file/rename"
      post(path, body: { fileUri: file_uri, newFileUri: new_file_uri })
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

    def import_translations(project_id: @project_id, file_uri:, locale:,
                            file:, file_type:, translation_state: nil,
                            overwrite: nil)
      raise(InvalidFile, file) unless Files.valid_file?(file)
      path = "/files-api/v2/projects/#{project_id}/locales/#{locale}/file/import"
      body = { file: file, fileUri: file_uri, fileType: file_type }
      body[:translationState] = translation_state unless translation_state.nil?
      body[:overwrite] = overwrite unless overwrite.nil?
      post(path, body: body)
    end

    def translate_file(project_id: @project_id, file_uri:, locale:, file:,
                       file_type:, retrieval_type: nil,
                       include_original_strings: nil)
      raise(InvalidFile, file) unless Files.valid_file?(file)
      path = "/files-api/v2/projects/#{project_id}/locales/#{locale}/file/get-translations"
      body = { file: file, fileUri: file_uri, fileType: file_type }
      body[:retrievalType] = retrieval_type unless retrieval_type.nil?
      body[:includeOriginalStrings] = include_original_strings unless include_original_strings.nil?
      post(path, body: body)
    end

    def file_last_modified(project_id: @project_id, file_uri:, locale: nil,
                           since: nil)
      path = ["/files-api/v2/projects/#{project_id}"]
      path << "locales/#{locale}" unless locale.nil?
      path << 'file/last-modified'
      path = path.join('/')
      query = { fileUri: file_uri }
      query[:lastModifiedAfter] = since.to_s.iso8601 unless since.nil?
      get(path, query: query)
    end

    InvalidFile = Class.new(ArgumentError)

    def self.valid_file?(content)
      %i[read content_type original_filename].all? do |required_method|
        content.respond_to?(required_method)
      end
    end
  end
end
