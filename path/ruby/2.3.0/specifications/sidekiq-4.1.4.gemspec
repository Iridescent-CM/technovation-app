# -*- encoding: utf-8 -*-
# stub: sidekiq 4.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sidekiq"
  s.version = "4.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mike Perham"]
  s.date = "2016-07-01"
  s.description = "Simple, efficient background processing for Ruby."
  s.email = ["mperham@gmail.com"]
  s.executables = ["sidekiq", "sidekiqctl"]
  s.files = ["bin/sidekiq", "bin/sidekiqctl"]
  s.homepage = "http://sidekiq.org"
  s.licenses = ["LGPL-3.0"]
  s.rubygems_version = "2.5.1"
  s.summary = "Simple, efficient background processing for Ruby"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, [">= 3.2.1", "~> 3.2"])
      s.add_runtime_dependency(%q<connection_pool>, [">= 2.2.0", "~> 2.2"])
      s.add_runtime_dependency(%q<concurrent-ruby>, ["~> 1.0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 1.4.7"])
      s.add_development_dependency(%q<redis-namespace>, [">= 1.5.2", "~> 1.5"])
      s.add_development_dependency(%q<minitest>, [">= 5.7.0", "~> 5.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rails>, [">= 3.2.0", "~> 4"])
    else
      s.add_dependency(%q<redis>, [">= 3.2.1", "~> 3.2"])
      s.add_dependency(%q<connection_pool>, [">= 2.2.0", "~> 2.2"])
      s.add_dependency(%q<concurrent-ruby>, ["~> 1.0"])
      s.add_dependency(%q<sinatra>, [">= 1.4.7"])
      s.add_dependency(%q<redis-namespace>, [">= 1.5.2", "~> 1.5"])
      s.add_dependency(%q<minitest>, [">= 5.7.0", "~> 5.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rails>, [">= 3.2.0", "~> 4"])
    end
  else
    s.add_dependency(%q<redis>, [">= 3.2.1", "~> 3.2"])
    s.add_dependency(%q<connection_pool>, [">= 2.2.0", "~> 2.2"])
    s.add_dependency(%q<concurrent-ruby>, ["~> 1.0"])
    s.add_dependency(%q<sinatra>, [">= 1.4.7"])
    s.add_dependency(%q<redis-namespace>, [">= 1.5.2", "~> 1.5"])
    s.add_dependency(%q<minitest>, [">= 5.7.0", "~> 5.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rails>, [">= 3.2.0", "~> 4"])
  end
end
