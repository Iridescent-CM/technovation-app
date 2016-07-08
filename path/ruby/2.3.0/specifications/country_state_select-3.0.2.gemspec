# -*- encoding: utf-8 -*-
# stub: country_state_select 3.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "country_state_select"
  s.version = "3.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Arvind Vyas"]
  s.date = "2016-03-17"
  s.description = "Country State Select is a Ruby Gem that aims to make Country and State/Province selection a cinch in Ruby on Rails environments."
  s.email = ["arvindvyas07@gmail.com"]
  s.homepage = "https://github.com/arvindvyas/Country-State-Select"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Dynamically select Country and State."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.6"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 0"])
      s.add_runtime_dependency(%q<simple_form>, ["~> 3.2"])
      s.add_runtime_dependency(%q<chosen-rails>, ["~> 1.4"])
      s.add_runtime_dependency(%q<compass-rails>, ["~> 2.0.4"])
      s.add_runtime_dependency(%q<city-state>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.6"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<simple_form>, ["~> 3.2"])
      s.add_dependency(%q<chosen-rails>, ["~> 1.4"])
      s.add_dependency(%q<compass-rails>, ["~> 2.0.4"])
      s.add_dependency(%q<city-state>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.6"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<simple_form>, ["~> 3.2"])
    s.add_dependency(%q<chosen-rails>, ["~> 1.4"])
    s.add_dependency(%q<compass-rails>, ["~> 2.0.4"])
    s.add_dependency(%q<city-state>, [">= 0"])
  end
end
