require 'rspec'
require 'webmock/rspec'
require 'simplecov'
require 'simplecov-json'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
]
SimpleCov.start

RSpec.configure do |config|
  config.color = true
  config.formatter     = 'documentation'
  WebMock.disable_net_connect!(allow: %w{codeclimate.com})
end
