puts "Ruby Version: #{RUBY_VERSION}"
puts "Ruby Platform: #{RUBY_PLATFORM}"

# this is a a wrapper script for loading the cadenza library, either from the git repo (../lib/cadenza.rb) or from rubygems
# by default the git repo will be loaded, to load using rubygems pass CADENZA_USE_GEM=yes as an environment variable
if ENV.fetch('CADENZA_USE_GEM', 'no').downcase == "yes"
   # TODO: would be nice to require a specific version
   require 'cadenza'
   puts "Cadenza Version: #{Cadenza::Version::STRING}"
else
   lib_directory = File.expand_path(File.join("..", "lib"), File.dirname(__FILE__))

   $LOAD_PATH.unshift(lib_directory)

   require_relative File.join('..', 'lib', 'cadenza')

   puts "Cadenza Version: #{Cadenza::Version::STRING}-HEAD"
end
