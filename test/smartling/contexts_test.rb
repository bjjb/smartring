# frozen_string_literal: true

require 'test_helper'
require 'smartling/contexts'

describe Smartling::Contexts do
  let(:smartling) do
    Class.new(Minitest::Mock) do
      include Smartling::Contexts
    end.new
  end

  after { smartling.verify }

  describe 'contexts' do
    it 'lists contexts the items of the smartling contexts result' do
      smartling.expect(:get, nil) do |path, query:|
        assert_equal path, '/context-api/v2/projects/1/contexts'
        assert_equal 'n', query.fetch(:nameFilter)
        assert_equal 1, query.fetch(:offset)
        assert_equal 'HTML', query.fetch(:type)
      end
      smartling.contexts(project_id: 1, name_filter: 'n',
                         offset: 1, type: 'HTML')
    end
  end

  describe 'context' do
    it 'gets the /context with the right param' do
      smartling.expect(:get, nil) do |path|
        assert_equal '/context-api/v2/projects/1/contexts/x', path
      end
      smartling.context(project_id: 1, context_uid: 'x')
    end
  end

  describe 'download_context' do
    it 'gets the /context with the right param' do
      smartling.expect(:get, nil) do |path|
        assert_equal '/context-api/v2/projects/1/contexts/x/content', path
      end
      smartling.download_context(project_id: 1, context_uid: 'x')
    end
  end

  describe 'delete_context' do
    it 'deletes the context at the right endpoing' do
      smartling.expect(:delete, nil) do |path|
        assert_equal '/context-api/v2/projects/1/contexts/x', path
      end
      smartling.delete_context(project_id: 1, context_uid: 'x')
    end
  end

  describe 'upload_context' do
    it 'posts the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:|
        assert_equal '/context-api/v2/projects/1/contexts', path
        assert_equal 'n', body.fetch(:name)
        assert_equal '<i>Hi</i>', body.fetch(:content).read
        assert_equal 'text/html', body.fetch(:content).content_type
        assert_equal 'n', body.fetch(:name)
      end
      content = UploadIO.new(StringIO.new('<i>Hi</i>'), 'text/html')
      smartling.upload_context(project_id: 1, content: content, name: 'n')
    end

    it 'prints a helpful message if the contextType is unsupported' do
      assert_raises Smartling::Contexts::InvalidContent do
        smartling.upload_context(project_id: 1, content: 'not a file')
      end
    end
  end

  describe 'upload_context_and_match' do
    it 'posts the right body to the right endpoint' do
      smartling.expect(:post, nil) do |path, body:|
        expected = '/context-api/v2/projects/1/contexts/'
        expected += 'upload-and-match-async'
        assert_equal expected, path
        assert_equal 'n', body.fetch(:name)
        assert_equal '<i>Hi</i>', body.fetch(:content).read
        assert_equal 'text/html', body.fetch(:content).content_type
        assert_equal %w[1 2 3], body.fetch(:matchParams)
        assert_equal 'n', body.fetch(:name)
      end
      content = UploadIO.new(StringIO.new('<i>Hi</i>'), 'text/html')
      smartling.upload_context_and_match(project_id: 1, content: content,
                                         match_params: %w[1 2 3], name: 'n')
    end

    it 'prints a helpful message if the contextType is unsupported' do
      assert_raises Smartling::Contexts::InvalidContent do
        smartling.upload_context(project_id: 1, content: 'not a file')
      end
    end
  end

  describe 'async context matching' do
    it 'posts to the right endpoint with the right params' do
      smartling.expect(:post, nil) do |path, query:, headers:|
        assert_equal '/context-api/v2/projects/1/contexts/x/match/async', path
        assert_equal %w[x], JSON.parse(query)['stringHashcodes']
        assert_equal 'application/json', headers['Content-Type']
      end
      smartling.match_context(project_id: 1, context_uid: 'x',
                              hashcodes: %w[x])
    end
  end

  describe 'retrieving match results' do
    it 'get the right endpoint' do
      smartling.expect(:get, nil) do |p|
        assert_equal '/context-api/v2/projects/1/match/8', p
      end
      smartling.context_matches(project_id: 1, match_id: 8)
    end
  end
end
