#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Prelude::Application.load_tasks

if Rails.env.development?
  Rake::Task["db:migrate"].enhance do
    Rake::Task["db:test:clone"].invoke
  end

  Rake::Task["db:rollback"].enhance do
    Rake::Task["db:test:clone"].invoke
  end
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new("spec:rcov") do |t|
    t.ruby_opts = [ "-rsimplecov" ]
    t.fail_on_error = false
  end
rescue LoadError
end

Rake::Task[:default].prerequisites.delete('spec')
task :default => "spec:rcov"
