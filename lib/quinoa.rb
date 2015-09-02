require File.join(File.dirname(__FILE__), './quinoa/version')
require 'bundler/setup'

#common dependencies
require 'rspec'
require 'rest-client'

#internal dependences
require File.join(File.dirname(__FILE__), './quinoa/service')

module Quinoa
end
