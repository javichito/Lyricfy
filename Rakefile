require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.test_files = FileList['spec/*_spec.rb', 'spec/providers/*_spec.rb']
  t.verbose = true
end

desc "Run tests"
task default: :test
