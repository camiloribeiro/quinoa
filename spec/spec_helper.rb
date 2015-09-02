require 'rspec'
require 'webmock/rspec'
require 'coveralls'

Coveralls.wear_merged!


RSpec.configure do |config|
  config.color = true
  config.formatter     = 'documentation'
end
