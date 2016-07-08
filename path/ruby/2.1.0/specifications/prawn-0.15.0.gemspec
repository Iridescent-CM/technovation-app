# -*- encoding: utf-8 -*-
# stub: prawn 0.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "prawn"
  s.version = "0.15.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregory Brown", "Brad Ediger", "Daniel Nelson", "Jonathan Greenberg", "James Healy"]
  s.date = "2014-02-16"
  s.description = "  Prawn is a fast, tiny, and nimble PDF generator for Ruby\n"
  s.email = ["gregory.t.brown@gmail.com", "brad@bradediger.com", "dnelson@bluejade.com", "greenberg@entryway.net", "jimmy@deefa.com"]
  s.homepage = "http://prawn.majesticseacreature.com"
  s.licenses = ["RUBY", "GPL-2", "GPL-3"]
  s.post_install_message = "\n  ********************************************\n\n\n  A lot has changed recently in Prawn.\n\n  Please read the changelog for details:\n\n  https://github.com/prawnpdf/prawn/wiki/CHANGELOG\n\n\n  ********************************************\n\n"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubyforge_project = "prawn"
  s.rubygems_version = "2.5.0"
  s.summary = "A fast and nimble PDF generator for Ruby"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ttfunk>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<pdf-core>, ["~> 0.1.3"])
      s.add_development_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
      s.add_development_dependency(%q<coderay>, ["~> 1.0.7"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<pdf-reader>, ["~> 1.2"])
    else
      s.add_dependency(%q<ttfunk>, ["~> 1.1.0"])
      s.add_dependency(%q<pdf-core>, ["~> 0.1.3"])
      s.add_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
      s.add_dependency(%q<coderay>, ["~> 1.0.7"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<ttfunk>, ["~> 1.1.0"])
    s.add_dependency(%q<pdf-core>, ["~> 0.1.3"])
    s.add_dependency(%q<pdf-inspector>, ["~> 1.1.0"])
    s.add_dependency(%q<coderay>, ["~> 1.0.7"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<pdf-reader>, ["~> 1.2"])
  end
end
