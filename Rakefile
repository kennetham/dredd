require 'rspec/core/rake_task'

task :default => [:rubocop, 'spec:all']

namespace :spec do
  desc 'Run All Tests'
  task :all => %w(spec:unit spec:integration)

  desc 'Run Unit Tests'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  desc 'Run Integration Tests'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
  end
end

desc 'Run Rubocop on the source'
task :rubocop do
  sh 'rubocop'
end