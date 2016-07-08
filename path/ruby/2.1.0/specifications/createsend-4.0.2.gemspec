# -*- encoding: utf-8 -*-
# stub: createsend 4.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "createsend"
  s.version = "4.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James Dennes"]
  s.date = "2014-10-15"
  s.description = "Implements the complete functionality of the Campaign Monitor API."
  s.email = ["jdennes@gmail.com"]
  s.homepage = "http://campaignmonitor.github.io/createsend-ruby/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.0"
  s.summary = "A library which implements the complete functionality of the Campaign Monitor API."

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.0"])
      s.add_runtime_dependency(%q<hashie>, ["~> 3.0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.10"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_development_dependency(%q<shoulda-context>, ["~> 1.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0"])
      s.add_development_dependency(%q<coveralls>, ["~> 0"])
    else
      s.add_dependency(%q<json>, ["~> 1.0"])
      s.add_dependency(%q<hashie>, ["~> 3.0"])
      s.add_dependency(%q<httparty>, ["~> 0.10"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_dependency(%q<shoulda-context>, ["~> 1.2"])
      s.add_dependency(%q<simplecov>, ["~> 0"])
      s.add_dependency(%q<coveralls>, ["~> 0"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.0"])
    s.add_dependency(%q<hashie>, ["~> 3.0"])
    s.add_dependency(%q<httparty>, ["~> 0.10"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3"])
    s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
    s.add_dependency(%q<shoulda-context>, ["~> 1.2"])
    s.add_dependency(%q<simplecov>, ["~> 0"])
    s.add_dependency(%q<coveralls>, ["~> 0"])
  end
end
