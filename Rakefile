# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

ActorsUniversity::Application.load_tasks

def setup_rspec
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:rspec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
  end

  task :default => [:rspec, :teaspoon]
end

begin
  setup_rspec 
rescue LoadError 
  #ie ignore when not in bundle
end

