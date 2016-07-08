# -*- encoding: utf-8 -*-
# stub: flag_shih_tzu 0.3.12 ruby lib

Gem::Specification.new do |s|
  s.name = "flag_shih_tzu"
  s.version = "0.3.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Peter Boling", "Patryk Peszko", "Sebastian Roebke", "David Anderson", "Tim Payton"]
  s.date = "2014-10-01"
  s.description = "Bit fields for ActiveRecord:\nThis gem lets you use a single integer column in an ActiveRecord model\nto store a collection of boolean attributes (flags). Each flag can be used\nalmost in the same way you would use any boolean attribute on an\nActiveRecord object.\n"
  s.email = "peter.boling@gmail.com"
  s.executables = ["test.bash"]
  s.files = ["bin/test.bash"]
  s.homepage = "https://github.com/pboling/flag_shih_tzu"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.0"
  s.summary = "Bit fields for ActiveRecord"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activerecord>, [">= 2.3.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_development_dependency(%q<reek>, [">= 1.2.8"])
      s.add_development_dependency(%q<roodi>, [">= 2.1.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.3.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_dependency(%q<reek>, [">= 1.2.8"])
      s.add_dependency(%q<roodi>, [">= 2.1.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.3.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 2.4.2"])
    s.add_dependency(%q<reek>, [">= 1.2.8"])
    s.add_dependency(%q<roodi>, [">= 2.1.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
