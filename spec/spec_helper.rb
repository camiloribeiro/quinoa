require 'rspec'
require 'webmock/rspec'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start


RSpec.configure do |config|
  config.color = true
  config.formatter     = 'documentation'
end
