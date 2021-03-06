$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rhinocatalog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rhinocatalog"
  s.version     = Rhinocatalog::VERSION
  s.authors     = ["Konstantin Chernyaev"]
  s.email       = ["kch@list.ru"]
  s.homepage    = "http://rhinoart.ru"
  s.summary     = "Rhino Catalog"
  s.description = "Rhino Catalog is a Product Catalog engine for Rhinoart CMS"  

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "mini_magick"
  s.add_dependency "carrierwave"
  s.add_dependency "actionpack-action_caching"
  s.add_dependency 'devise'
  s.add_dependency 'remotipart', '~> 1.2'
  s.add_dependency 'sanitize'
  s.add_dependency 'swagger-docs'
  s.add_dependency 'grape-swagger-ui'
  s.add_dependency 'jbuilder'
end
