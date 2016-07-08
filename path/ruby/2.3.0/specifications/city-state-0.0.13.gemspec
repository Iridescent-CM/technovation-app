# -*- encoding: utf-8 -*-
# stub: city-state 0.0.13 ruby lib

Gem::Specification.new do |s|
  s.name = "city-state"
  s.version = "0.0.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Daniel Loureiro"]
  s.date = "2015-04-02"
  s.description = "Useful to make forms and validations. It uses MaxMind database."
  s.email = ["loureirorg@gmail.com"]
  s.homepage = "https://github.com/loureirorg/city-state"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Simple list of cities and states of the world"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 1.1"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rubyzip>, ["~> 1.1"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rubyzip>, ["~> 1.1"])
  end
end
