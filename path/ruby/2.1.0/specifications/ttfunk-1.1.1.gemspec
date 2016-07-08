# -*- encoding: utf-8 -*-
# stub: ttfunk 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ttfunk"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregory Brown", "Brad Ediger", "Daniel Nelson", "Jonathan Greenberg", "James Healy"]
  s.date = "2014-02-24"
  s.description = "Get Ya TrueType Funk On! (Font Metrics Parser for Prawn)"
  s.email = ["gregory.t.brown@gmail.com", "brad@bradediger.com", "dnelson@bluejade.com", "greenberg@entryway.net", "jimmy@deefa.com"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.0"
  s.summary = "TrueType Font Metrics Parser"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
