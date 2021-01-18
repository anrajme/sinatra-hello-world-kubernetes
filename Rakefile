require 'rake/testtask'
require 'rake/test_unit'

task default: %i(test)
task testunit: 'ci:setup:testunit'

namespace :ci do
  task :all => ['ci:setup:testunit', 'test']
end

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
  t.warning = false
  t.verbose = true
end
