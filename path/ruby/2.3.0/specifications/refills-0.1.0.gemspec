# -*- encoding: utf-8 -*-
# stub: refills 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "refills"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Christian Reuter", "Jo\u{eb}l Quenneville", "Lisa Sy", "Magnus Gyllensward", "Paul Smith", "Tyson Gach"]
  s.date = "2015-02-02"
  s.description = "Prepackaged patterns and components built with Bourbon, Neat and Bitters."
  s.email = "design+bourbon@thoughtbot.com"
  s.homepage = "http://refills.bourbon.io"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Prepackaged patterns and components built with Bourbon, Neat and Bitters."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
