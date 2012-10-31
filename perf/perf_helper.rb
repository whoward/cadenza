require 'benchmark'

# this is a a wrapper script for loading the cadenza library, either from the git repo (../lib/cadenza.rb) or from rubygems
# by default the git repo will be loaded, to load using rubygems pass CADENZA_USE_GEM=yes as an environment variable
if ENV.fetch('CADENZA_USE_GEM', 'no').downcase == "yes"
   puts "loading cadenza from rubygems"
   require 'rubygems'
   require 'cadenza'
else
   puts "loading cadenza from git repository"

   lib_directory = File.expand_path(File.join("..", "lib"), File.dirname(__FILE__))

   $:.unshift(lib_directory)

   require File.join(lib_directory, 'cadenza')
end

# define some helpful methods
def fixture_filename(filename)
   File.expand_path(File.join("fixtures", filename), File.dirname(__FILE__))
end

def fixture_data(filename)
   File.read(fixture_filename filename)
end

def template_data(template_name, language)
   fixture_data "#{template_name}/index.#{language}"
end

def cadenza_template_data(template_name)
   template_data template_name, "cadenza"
end

def liquid_template_data(template_name)
   template_data template_name, "liquid"
end
