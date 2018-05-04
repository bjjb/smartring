# frozen_string_literal: true

require 'test_helper'
require 'smartling/files'

describe Smartling::Files do
  let(:smartling) do
    Class.new(Minitest::Mock) do
      include Smartling::Files
    end.new
  end

  after { smartling.verify }

  describe 'files' do
    it 'lists files the items of the smartling files result' do
      smartling.expect(:get, nil, ['/files-api/v2/projects/1/files/list'])
      smartling.files(project_id: 1)
    end
  end

  describe 'file' do
    it 'gets the /file/status endpoint with the right param' do
      smartling.expect(:get, nil) do |path, query:|
        assert_match %r{files-api/v2/projects/1/file/status$}, path
        assert_equal({ fileUri: 'x' }, query)
      end
      smartling.file(project_id: 1, file_uri: 'x')
    end
  end

  describe 'file with locale' do
    it 'gets the /locale/x/file/status endpoint with the right params' do
      smartling.expect(:get, nil) do |path, query:|
        assert_match %r{files-api/v2/projects/1/locales/es/file/status$}, path
        assert_equal({ fileUri: 'x' }, query)
      end
      smartling.file(project_id: 1, file_uri: 'x', locale: 'es')
    end
  end

  describe 'delete_file' do
    it 'posts the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:|
        assert_match %r{files-api/v2/projects/1/file/delete$}, path,
                     assert_equal({ fileUri: 'x' }, body)
      end
      smartling.delete_file(project_id: 1, file_uri: 'x')
    end
  end

  describe 'rename_file' do
    it 'posts the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:|
        assert_match %r{files-api/v2/projects/1/file/rename$}, path,
                     assert_equal({ fileUri: 'x', newFileUri: 'y' }, body)
      end
      smartling.rename_file(project_id: 1, file_uri: 'x', new_file_uri: 'y')
    end
  end

  describe 'upload_file' do
    it 'posts the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:|
        assert_equal '/files-api/v2/projects/1/file', path
        assert_equal 'x', body.fetch(:fileUri)
        assert_equal 'json', body.fetch(:fileType)
        assert_equal '"hello"', body.fetch(:file).read
        assert_equal 'application/json', body.fetch(:file).content_type
        assert_equal 'cb', body.fetch(:callback)
        assert_equal %w[a b], body.fetch(:localeIdsToAuthorize)
        assert_equal 'bar', body.fetch('smartling.foo')
        assert_equal false, body.fetch(:authorize)
      end
      file = UploadIO.new(StringIO.new('"hello"'), 'application/json')
      smartling.upload_file(project_id: 1, file: file, file_uri: 'x',
                            file_type: 'json', callback: 'cb',
                            locales_to_authorize: %w[a b],
                            smartling: { foo: 'bar' }, authorize: false)
    end
    it 'throws an exception if the file is not a file' do
      assert_raises Smartling::Files::InvalidFile do
        smartling.upload_file(project_id: 1, file: 'hi', file_uri: 'x',
                              file_type: 'bullshit')
      end
    end
  end
end
