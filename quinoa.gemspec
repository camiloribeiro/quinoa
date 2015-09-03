# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quinoa/version"

Gem::Specification.new do |s|
  s.name        = "quinoa"
  s.version     = Quinoa::VERSION
  s.authors     = ["Camilo Ribeiro"]
  s.email       = ["camilo@camiloribeiro.com"]
  s.homepage    = "http://github.com/camiloribeiro/quinoa"
  s.license     = "Apache 2.0"
  s.summary     = %q{Service-Object Model for Ruby}
  s.description = %q{Quinoa is a light and nutritive framework that allows automate service level tests using object model}

  s.rubyforge_project = "quinoa"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.default_executable = 'quinoa'

  s.require_paths = ["lib"]

  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'coveralls', '~> 0'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'nyan-cat-formatter', '~> 0'
  s.add_development_dependency 'cucumber', '~> 0'
  s.add_development_dependency 'webmock', '~> 1.21.0'

  s.add_dependency 'rest-client', '~> 1.8.0'
  s.add_dependency 'rspec', '~> 3.3.0'

end
