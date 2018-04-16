# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.warning = false
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

begin
  require 'rubocop/rake_task'
  desc 'Run RuboCop on the sources'
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.patterns = ['{lib,test}/**/*.rb', 'test/**/*.rb']
    t.formatters = ['files']
    t.fail_on_error = true
  end
rescue LoadError => e
  warn 'No Rubocop available.'
end

task default: :test
