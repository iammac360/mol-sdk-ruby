begin
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'

    lib_directories = Dir.glob('lib/mol/*/').map{|dir_name| dir_name[0..-2]}
    lib_directories.each do |dir|
      add_group dir.split('/').last, dir
    end
  end
rescue LoadError
end if ENV['COVERAGE']

$: << File.join(File.dirname(File.dirname(__FILE__)), "lib")

require 'rspec'
require 'shoulda-matchers'
require 'webmock/rspec'
require 'debugger'
require 'mol/version'

include MOL

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true
end
