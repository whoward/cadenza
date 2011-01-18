require 'rubygems'
require 'rake'
require 'jeweler'
require File.join(File.dirname(__FILE__), 'lib', 'cadenza', 'version')

Jeweler::Tasks.new do |gem|
  gem.name        = "cadenza"
  gem.summary     = "Powerful text templating language similar to Smarty/Liquid/Django"
  #gem.description = "TODO: longer description"

  gem.homepage       = "http://github.com/whoward/Cadenza"
  gem.authors        = ["William Howard"]
  gem.email          = "whoward.tke@gmail.com"

  gem.version = Cadenza::Version::STRING

  gem.files.include 'lib/**/*.rb'
  gem.files.exclude ''
end

# require every *.rake file inside of the tasks subdirectory
Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')].each {|f| load f}
