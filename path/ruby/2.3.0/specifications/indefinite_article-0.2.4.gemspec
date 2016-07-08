# -*- encoding: utf-8 -*-
# stub: indefinite_article 0.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "indefinite_article"
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andrew Rossmeissl", "Shane Brinkman-Davis"]
  s.date = "2015-05-28"
  s.description = "Adds indefinite article methods to String and Symbol"
  s.email = ["andy@rossmeissl.net"]
  s.homepage = "http://github.com/rossmeissl/indefinite_article"
  s.rubygems_version = "2.5.1"
  s.summary = "Adds indefinite article methods to String and Symbol"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<minitest>, ["~> 5.1"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<minitest>, ["~> 5.1"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<minitest>, ["~> 5.1"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
