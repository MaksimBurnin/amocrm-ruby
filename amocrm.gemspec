$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "amocrm/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "amocrm"
  s.version     = Amocrm::VERSION
  s.authors     = ["Maksim Burnin"]
  s.email       = ["maksim.burnin@gmail.com"]
  s.homepage    = ""
  s.summary     = "AmoCRM API iterface."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"
end
