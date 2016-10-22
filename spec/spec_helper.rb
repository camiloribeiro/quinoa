require 'rspec'
require 'webmock/rspec'
require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.color = true
  config.formatter     = 'documentation'
  WebMock.disable_net_connect!(allow: %w{codeclimate.com})
end
