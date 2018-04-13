# frozen_string_literal: true

require 'test_helper'
require 'smartling/strings'

describe Smartling::Strings do
  let(:smartling) do
    Class.new(Minitest::Mock) do
      include Smartling::Strings
    end.new
  end

  describe 'source_strings' do
    it 'lists files the items of the smartling files result' do
      smartling.expect(:get, nil) do |path, query:|
        assert_equal path, '/strings-api/v2/projects/1/source-strings'
        assert_equal 'x', query.fetch(:fileUri)
        assert_equal ['a'], query.fetch(:stringHashcodes)
        assert_equal 99, query.fetch(:limit)
        assert_equal 2, query.fetch(:offset)
      end
      smartling.source_strings(project_id: 1, file_uri: 'x', hashcodes: ['a'],
                               limit: 99, offset: 2)
    end
  end
end
