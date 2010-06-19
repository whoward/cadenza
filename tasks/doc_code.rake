
begin
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
rescue LoadError => e
  puts "YARD does not appear to be installed, code documentation tasks will not be shown"
end