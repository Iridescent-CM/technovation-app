# -*- encoding: utf-8 -*-
# stub: dotenv-rails 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "dotenv-rails"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brandon Keepers"]
  s.date = "2014-10-14"
  s.description = "Autoload dotenv in Rails."
  s.email = ["brandon@opensoul.org"]
  s.homepage = "https://github.com/bkeepers/dotenv"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.0"
  s.summary = "Autoload dotenv in Rails."

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dotenv>, ["= 1.0.2"])
      s.add_development_dependency(%q<spring>, [">= 0"])
      s.add_development_dependency(%q<railties>, [">= 0"])
    else
      s.add_dependency(%q<dotenv>, ["= 1.0.2"])
      s.add_dependency(%q<spring>, [">= 0"])
      s.add_dependency(%q<railties>, [">= 0"])
    end
  else
    s.add_dependency(%q<dotenv>, ["= 1.0.2"])
    s.add_dependency(%q<spring>, [">= 0"])
    s.add_dependency(%q<railties>, [">= 0"])
  end
end
