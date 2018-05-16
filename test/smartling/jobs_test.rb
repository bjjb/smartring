# frozen_string_literal: true

require 'test_helper'
require 'smartling/jobs'

describe Smartling::Jobs do
  let(:smartling) do
    Class.new(Minitest::Mock) do
      include Smartling::Jobs
    end.new
  end

  after { smartling.verify }

  describe 'jobs' do
    it 'GETs the right path and query params' do
      smartling.expect(:get, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs}, path
      end
      smartling.jobs(project_id: 1)
    end

    it 'passes other arguments too' do
      smartling.expect(:get, nil) do |path, query:|
        assert_match %r{jobs-api/v3/projects/1/jobs}, path
        assert_equal 'ASC', query[:sortDirection]
        assert_equal 'foo', query[:jobName]
        assert_equal %w(1 2 3), query[:translationJobUids]
        assert_equal 100, query[:limit]
        assert_equal 20, query[:offset]
      end
      smartling.jobs(project_id: 1, job_name: 'foo', sort_direction: 'ASC',
                    translation_job_uids: %w(1 2 3), limit: 100, offset: 20)
    end
  end

  describe 'create_job' do
    it 'POSTs the right path and body' do
      smartling.expect(:post, nil) do |path, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs}, path
        assert_equal 'application/json', headers['Content-Type']
      end
      smartling.create_job(project_id: 1)
    end

    it 'builds the correct body' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal 'foo', body[:jobName]
        assert_equal Time.parse('2000-01-01').iso8601, body[:dueDate]
        assert_equal %w(de), body[:targetLocaleIds]
        assert_equal '123', body[:referenceNumber]
        assert_equal 'https://foo.bar', body[:callbackUrl]
      end
      smartling.create_job(project_id: 1, job_name: 'foo',
                           target_locale_ids: %w(de),
                           due_date: Time.parse('2000-01-01'),
                           reference_number: '123',
                           callback_url: 'https://foo.bar')
    end
  end

  describe 'delete_job' do
    it 'DELETES the right path' do
      smartling.expect(:delete, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs/4}, path
      end
      smartling.delete_job(project_id: 1, translation_job_uid: 4)
    end
  end

  describe 'job' do
    it 'GETs the right endpoint' do
      smartling.expect(:get, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs/x}, path
      end
      smartling.job(project_id: 1, translation_job_uid: 'x')
    end
  end

  describe 'update_job' do
    it 'PUTs the right data to the right endpoint' do
      smartling.expect(:put, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal 'D', body[:description]
        assert_equal Time.parse('2001-01-01').iso8601, body[:dueDate]
        assert_equal '123', body[:referenceNumber]
        assert_equal 'https://x.y', body[:callbackUrl]
        assert_equal 'GET', body[:callbackMethod]
      end
      smartling.update_job(project_id: 1, translation_job_uid: 'x',
                           description: 'D', due_date: '2001-01-01',
                           reference_number: '123', job_name: 'N',
                           callback_url: 'https://x.y',
                           callback_method: 'GET')
    end
  end

  describe 'search_jobs' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/search}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal %w(a b), body[:hashcodes]
        assert_equal %w(x y), body[:fileUris]
        assert_equal %w(1 2), body[:translationJobUids]
      end
      smartling.search_jobs(project_id: 1, hashcodes: %w(a b),
                            file_uris: %w(x y),
                            translation_job_uids: %w(1 2))
    end
  end

  describe 'job_files' do
    it 'GETs the right endpoint' do
      smartling.expect(:get, nil) do |path, query:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/files}, path
        assert_equal 3, query[:limit]
        assert_equal 1, query[:offset]
      end
      smartling.job_files(project_id: 1, translation_job_uid: 'x', limit: 3,
                          offset: 1)
    end
  end

  describe 'job_progress (with a file uid)' do
    it 'GETs job progress for a file' do
      smartling.expect(:get, nil) do |path, query:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/progress}, path
        assert_equal 'a', query[:fileUri]
      end
      smartling.job_progress(project_id: 1, translation_job_uid: 'x',
                             file_uri: 'a')
    end
  end

  describe 'job_progress (without a file uid)' do
    it 'GETs job progress for all files' do
      smartling.expect(:get, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/progress}, path
      end
      smartling.job_progress(project_id: 1, translation_job_uid: 'x')
    end
  end

  describe 'add_strings_to_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/strings/add}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal true, body[:moveEnabled]
        assert_equal %w(x y), body[:hashcodes]
        assert_equal %w(de), body[:targetLocaleIds]
      end
      smartling.add_strings_to_job(project_id: 1, translation_job_uid: 'x',
                                   move_enabled: true, hashcodes: %w(x y),
                                   target_locale_ids: %w(de))
    end
  end

  describe 'remove_strings_from_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/strings/remove}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal %w(x y), body[:hashcodes]
        assert_equal %w(de), body[:localeIds]
      end
      smartling.remove_strings_from_job(project_id: 1,
                                        translation_job_uid: 'x',
                                        hashcodes: %w(x y),
                                        locale_ids: %w(de))
    end
  end

  describe 'add_file_to_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/file/add}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal 'z', body[:fileUri]
        assert_equal %w(de), body[:targetLocaleIds]
      end
      smartling.add_file_to_job(project_id: 1, translation_job_uid: 'x',
                                file_uri: 'z', target_locale_ids: %w(de))
    end
  end

  describe 'remove_file_from_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/file/remove}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal 'z', body[:fileUri]
      end
      smartling.remove_file_from_job(project_id: 1, translation_job_uid: 'x',
                                     file_uri: 'z')
    end
  end

  describe 'add_locale_to_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/locales/de-AT}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal true, body[:syncContent]
      end
      smartling.add_locale_to_job(project_id: 1, translation_job_uid: 'x',
                                  locale_id: 'de-AT', sync_content: true)
    end
  end

  describe 'remove_locale_from_job' do
    it 'DELETEs the right endpoint' do
      smartling.expect(:delete, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/locales/de-AT}, path
      end
      smartling.remove_locale_from_job(project_id: 1,
                                       translation_job_uid: 'x',
                                       locale_id: 'de-AT')
    end
  end

  describe 'close_job' do
    it 'POSTs to the right endpoint' do
      smartling.expect(:post, nil) do |path, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/close}, path
      end
      smartling.close_job(project_id: 1, translation_job_uid: 'x')
    end
  end

  describe 'cancel_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/cancel}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        assert_equal 'Laziness', body[:reason]
      end
      smartling.cancel_job(project_id: 1, translation_job_uid: 'x',
                           reason: 'Laziness')
    end
  end

  describe 'authorize_job' do
    it 'POSTs the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/authorize}, path
        assert_equal 'application/json', headers['Content-Type']
        body = HipsterHash[JSON.parse(body)]
        workflow = body[:localeWorkflows].first
        assert_equal 'a', body[:localeWorkflows][0][:targetLocaleId]
        assert_equal 'b', body[:localeWorkflows][0][:workflowUid]
        assert_equal 'c', body[:localeWorkflows][1][:targetLocaleId]
        assert_equal 'd', body[:localeWorkflows][1][:workflowUid]
      end
      locale_workflows = [
        { target_locale_id: 'a', workflow_uid: 'b' },
        { target_locale_id: 'c', workflow_uid: 'd' }
      ]
      smartling.authorize_job(project_id: 1, translation_job_uid: 'x',
                              locale_workflows: locale_workflows)
    end

    it 'does not require workflows' do
      smartling.expect(:post, nil) do |path, headers:|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/authorize}, path
      end
      smartling.authorize_job(project_id: 1, translation_job_uid: 'x')
    end

    it 'explains about workflows if needed' do
      assert_raises(ArgumentError) do
        smartling.authorize_job(project_id: 1, translation_job_uid: 'x',
                                locale_workflows: {})
      end
    end
  end

  describe 'job_process' do
    it 'GETs the right endpoint' do
      smartling.expect(:get, nil) do |path|
        assert_match %r{jobs-api/v3/projects/1/jobs/x/processes/y}, path
      end
      smartling.job_process(project_id: 1, translation_job_uid: 'x',
                            process_uid: 'y')
    end
  end
end
