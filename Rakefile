ENV['RACK_ENV'] ||= 'test'

require 'rubocop/rake_task'
require 'rspec/core/rake_task'        if ENV['RACK_ENV'] != 'production'
require_relative 'lib/main_script.rb'

RuboCop::RakeTask.new do |task|
  task.fail_on_error = true
end

if ENV['RACK_ENV'] != 'production'
  RSpec::Core::RakeTask.new(:spec)

  task default: [:rubocop, :spec]
end
