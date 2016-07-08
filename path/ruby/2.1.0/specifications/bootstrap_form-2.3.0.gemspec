# -*- encoding: utf-8 -*-
# stub: bootstrap_form 2.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap_form"
  s.version = "2.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Stephen Potenza", "Carlos Lopes"]
  s.date = "2015-02-18"
  s.description = "bootstrap_form is a rails form builder that makes it super easy to create beautiful-looking forms using Twitter Bootstrap 3+"
  s.email = ["potenza@gmail.com", "carlos.el.lopes@gmail.com"]
  s.homepage = "http://github.com/bootstrap-ruby/rails-bootstrap-forms"
  s.rubygems_version = "2.5.0"
  s.summary = "Rails form builder that makes it easy to style forms using Twitter Bootstrap 3+"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, ["~> 4.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<timecop>, ["~> 0.7.1"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 4.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<timecop>, ["~> 0.7.1"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 4.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<timecop>, ["~> 0.7.1"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
