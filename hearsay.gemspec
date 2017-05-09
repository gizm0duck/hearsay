$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hearsay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hearsay"
  s.version     = Hearsay::VERSION
  s.authors     = ["Shane Wolf"]
  s.email       = ["shanewolf@gmail.com"]
  s.summary     = "Pub sub for rails model lifecycle events."
  s.description = "Pub sub for rails model lifecycle events."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.0"

  s.add_development_dependency "sqlite3"
end
