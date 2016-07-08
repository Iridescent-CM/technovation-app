# -*- encoding: utf-8 -*-
# stub: nested_form_fields 0.7.8 ruby lib

Gem::Specification.new do |s|
  s.name = "nested_form_fields"
  s.version = "0.7.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nico Ritsche"]
  s.date = "2016-05-07"
  s.description = "Rails gem for dynamically adding and removing nested has_many association fields in a form.\n                         Uses jQuery and supports multiple nesting levels. Requires Ruby 1.9+ and the asset pipeline."
  s.email = ["ncrdevmail@gmail.com"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Rails gem for dynamically adding and removing nested has_many association fields in a form."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<coffee-rails>, [">= 3.2.1"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.9"])
      s.add_development_dependency(%q<assert_difference>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 3.1.5"])
      s.add_development_dependency(%q<haml-rails>, [">= 0"])
      s.add_development_dependency(%q<sass-rails>, ["~> 3.2.3"])
      s.add_development_dependency(%q<test-unit>, ["= 1.2.3"])
    else
      s.add_dependency(%q<rails>, [">= 3.2.0"])
      s.add_dependency(%q<coffee-rails>, [">= 3.2.1"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.9"])
      s.add_dependency(%q<assert_difference>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 3.1.5"])
      s.add_dependency(%q<haml-rails>, [">= 0"])
      s.add_dependency(%q<sass-rails>, ["~> 3.2.3"])
      s.add_dependency(%q<test-unit>, ["= 1.2.3"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2.0"])
    s.add_dependency(%q<coffee-rails>, [">= 3.2.1"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.9"])
    s.add_dependency(%q<assert_difference>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<selenium-webdriver>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 3.1.5"])
    s.add_dependency(%q<haml-rails>, [">= 0"])
    s.add_dependency(%q<sass-rails>, ["~> 3.2.3"])
    s.add_dependency(%q<test-unit>, ["= 1.2.3"])
  end
end
