require 'yard'

namespace :doc do
  
   YARD::Rake::YardocTask.new do |yard|
      root_directory = File.join(File.dirname(__FILE__), '..')

      yard.files = Dir.glob(File.join(root_directory, 'lib', '**', '*.rb'))

      yard.options << '-o' << File.join(root_directory, 'doc', 'plugin')
      yard.options << '--verbose'
      yard.options << '--db' << File.join(root_directory, 'doc', '.yardb')
   end
  
end