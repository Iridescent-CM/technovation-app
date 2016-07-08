# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sidekiq/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mike Perham"]
  gem.email         = ["mperham@gmail.com"]
  gem.summary       = "Simple, efficient background processing for Ruby"
  gem.description   = "Simple, efficient background processing for Ruby."
  gem.homepage      = "http://sidekiq.org"
  gem.license       = "LGPL-3.0"

  gem.executables   = ['sidekiq', 'sidekiqctl']
  gem.files         = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "sidekiq"
  gem.require_paths = ["lib"]
  gem.version       = Sidekiq::VERSION
  gem.add_dependency                  'redis', '~> 3.2', '>= 3.2.1'
  gem.add_dependency                  'connection_pool', '~> 2.2', '>= 2.2.0'
  gem.add_dependency                  'concurrent-ruby', '~> 1.0'
  gem.add_dependency                  'sinatra', '>= 1.4.7'
  gem.add_development_dependency      'redis-namespace', '~> 1.5', '>= 1.5.2'
  gem.add_development_dependency      'minitest', '~> 5.7', '>= 5.7.0'
  gem.add_development_dependency      'rake', '~> 10.0'
  gem.add_development_dependency      'rails', '~> 4', '>= 3.2.0'
end
