# -*- encoding: utf-8 -*-
# stub: pdf-core 0.1.6 ruby lib

Gem::Specification.new do |s|
  s.name = "pdf-core"
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregory Brown", "Brad Ediger", "Daniel Nelson", "Jonathan Greenberg", "James Healy"]
  s.date = "2014-02-16"
  s.description = "PDF::Core is used by Prawn to render PDF documents"
  s.email = ["gregory.t.brown@gmail.com", "brad@bradediger.com", "dnelson@bluejade.com", "greenberg@entryway.net", "jimmy@deefa.com"]
  s.homepage = "http://prawn.majesticseacreature.com"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubyforge_project = "prawn"
  s.rubygems_version = "2.5.0"
  s.summary = "PDF::Core is used by Prawn to render PDF documents"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<pdf-reader>, ["~> 1.2"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
