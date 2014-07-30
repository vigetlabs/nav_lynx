$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nav_lynx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nav_lynx"
  s.version     = NavLYNX::VERSION
  s.authors     = ["Dan Tello", "Patrick Reagan", "Brian Landau"]
  s.email       = ["dan.tello@viget.com", "patrick.reagan@viget.com", "brian.landau@viget.com"]
  s.homepage    = "http://github.com/vigetlabs/nav_lynx"
  s.summary     = "Rails helper to generate navigation links with a selected class."
  s.description = "Rails helper to generate navigation links with a selected class."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.add_dependency "rails", ">= 3.1.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '~> 2.14.0'
  s.add_development_dependency 'capybara', '~> 2.2.0'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec-html-matchers', '< 0.6.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'coveralls'
end
