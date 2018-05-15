# frozen_string_literal: true

module Smartling
  # Methods for using the Smartling files API
  module Jobs
    def jobs(project_id: @project_id, job_name: nil, translation_job_uids:
             nil, translation_job_status: nil, limit: nil, offset: nil,
             sort_by: nil, sort_direction: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs"
      query = {}
      query[:jobName] = job_name unless job_name.nil?
      query[:translationJobUids] = translation_job_uids 
      query[:translationJobStatus] = translation_job_status unless translation_job_status.nil?
      query[:limit] = limit unless limit.nil?
      query[:offset] = offset unless offset.nil?
      query[:sortBy] = sort_by unless sort_by.nil?
      query[:sortDirection] = sort_direction unless sort_direction.nil?
      return get(path) if query.empty?
      return get(path, query: query)
    end

    def create_job(project_id: @project_id, job_name: nil, target_locale_ids:
                   nil, description: nil, due_date: nil, reference_number:
                   nil, callback_url: nil, callback_method: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs"
      body = {}
      body[:jobName] = job_name unless job_name.nil?
      unless target_locale_ids.nil?
        body[:targetLocaleIds] = target_locale_ids
      end
      body[:description] = description unless description.nil?
      body[:dueDate] = Time.parse(due_date.to_s).iso8601 unless due_date.nil?
      body[:referenceNumber] = reference_number unless reference_number.nil?
      body[:callbackUrl] = callback_url unless callback_url.nil?
      body[:callbackMethod] = callback_method unless callback_method.nil?
      headers = { 'Content-Type' => 'application/json' }
      return post(path, headers: headers) if body.empty?
      post(path, body: body.to_json, headers: headers)
    end

    def job(project_id: @project_id, translation_job_uid:)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      get(path)
    end

    def update_job(project_id: @project_id, translation_job_uid:,
                   job_name: nil, description: nil, due_date: nil,
                   reference_number: nil, callback_url: nil,
                   callback_method: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      body = {}
      body[:jobName] = job_name unless job_name.nil?
      body[:description] = description unless description.nil?
      body[:dueDate] = Time.parse(due_date.to_s).iso8601 unless due_date.nil?
      body[:referenceNumber] = reference_number unless reference_number.nil?
      body[:callbackUrl] = callback_url unless callback_url.nil?
      body[:callbackMethod] = callback_method unless callback_method.nil?
      headers = { 'Content-Type' => 'application/json' }
      return put(path, headers: headers) if body.empty?
      put(path, body: body.to_json, headers: headers)
    end

    def search_jobs(project_id: @project_id, translation_job_uids: nil,
                    file_uris: nil, hashcodes: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/search"
      body = {}
      unless  translation_job_uids.nil?
        body[:translationJobUids] = translation_job_uids
      end
      body[:hashcodes] = hashcodes unless hashcodes.nil?
      body[:fileUris] = file_uris unless file_uris.nil?
      headers = { 'Content-Type' => 'application/json' }
      return post(path, headers: headers) if body.empty?
      post(path, body: body.to_json, headers: headers)
    end

    def job_files(project_id: @project_id, translation_job_uid:, offset: nil,
                  limit: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/files'
      query = {}
      query[:limit] = limit unless limit.nil?
      query[:offset] = offset unless offset.nil?
      return get(path) if query.empty?
      get(path, query: query)
    end

    def job_progress(project_id: @project_id, translation_job_uid:,
                     file_uri: nil, offset: nil, limit: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/progress'
      query = {}
      query[:fileUri] = file_uri unless file_uri.nil?
      query[:limit] = limit unless limit.nil?
      query[:offset] = offset unless offset.nil?
      return get(path) if query.empty?
      get(path, query: query)
    end

    def add_file_to_job(project_id: @project_id, translation_job_uid:,
                        file_uri:, target_locale_ids: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/file/add'
      body = {}
      body[:fileUri] = file_uri
      body[:targetLocaleIds] = target_locale_ids unless target_locale_ids.nil?
      headers = { 'Content-Type' => 'application/json' }
      post(path, body: body.to_json, headers: headers)
    end

    def remove_file_from_job(project_id: @project_id, translation_job_uid:, file_uri:)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path =  path + '/file/remove'
      body = { fileUri: file_uri }
      headers = { 'Content-Type' => 'application/json' }
      post(path, body: body.to_json, headers: headers)
    end

    def add_strings_to_job(project_id: @project_id, translation_job_uid:,
                           hashcodes:, target_locale_ids: nil,
                           move_enabled: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/strings/add'
      body = {}
      body[:hashcodes] = hashcodes
      body[:targetLocaleIds] = target_locale_ids unless target_locale_ids.nil?
      body[:moveEnabled] = move_enabled unless move_enabled.nil?
      headers = { 'Content-Type' => 'application/json' }
      post(path, body: body.to_json, headers: headers)
    end

    def remove_strings_from_job(project_id: @project_id, translation_job_uid:,
                                hashcodes:, locale_ids: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/strings/remove'
      body = {}
      body[:hashcodes] = hashcodes
      body[:localeIds] = locale_ids unless locale_ids.nil?
      headers = { 'Content-Type' => 'application/json' }
      return post(path, headers: headers) if body.empty?
      post(path, body: body.to_json, headers: headers)
    end

    def add_locale_to_job(project_id: @project_id, translation_job_uid:,
                          locale_id:, sync_content: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + "/locales/#{locale_id}"
      body = {}
      body[:syncContent] = sync_content unless sync_content.nil?
      headers = { 'Content-Type' => 'application/json' }
      return post(path, headers: headers) if body.nil?
      post(path, body: body.to_json, headers: headers)
    end

    def remove_locale_from_job(project_id: @project_id, translation_job_uid:,
                               locale_id: )
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + "/locales/#{locale_id}"
      delete(path)
    end

    def close_job(project_id: @project_id, translation_job_uid:)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/close'
      headers = { 'Content-Type' => 'application/json' }
      post(path, headers: headers)
    end

    def cancel_job(project_id: @project_id, translation_job_uid:, reason: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/cancel'
      body = {}
      body[:reason] = reason unless reason.nil?
      headers = { 'Content-Type' => 'application/json' }
      return post(path, headers: headers) if body.nil?
      post(path, body: body.to_json, headers: headers)
    end

    def authorize_job(project_id: @project_id, translation_job_uid:,
                      locale_workflows: nil)
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + '/authorize'
      headers = { 'Content-Type' => 'application/json' }
      case locale_workflows
      when nil
        return post(path, headers: headers)
      when Array
        body = {}
        body[:localeWorkflows] = locale_workflows.map do |lw|
          locale = lw[:target_locale_id] || lw.fetch('target_locale_id')
          workflow = lw[:workflow_uid] || lw.fetch('workflow_uid')
          { targetLocaleId: locale, workflowUid: workflow }
        end
        post(path, body: body.to_json, headers: headers)
      else
        raise ArgumentError, 'locale_workflows should be an array'
      end
    end

    def job_process(project_id: @project_id, translation_job_uid:,
                    process_uid: )
      path = "/jobs-api/v3/projects/#{project_id}/jobs/#{translation_job_uid}"
      path = path + "/processes/#{process_uid}"
      get(path)
    end
  end
end
