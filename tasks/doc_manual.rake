
namespace :doc do

  desc "compile the user manual for cadenza"
  task :manual => :environment do
    # get some useful directories before we get started
    root_directory = File.join(File.dirname(__FILE__), '..')
    source_directory = File.join(root_directory, 'doc', 'src')
    output_directory = File.join(root_directory, 'doc', 'manual')
    
    # This will be the context passed to EVERY example
    context_file = File.join(source_directory, 'context.rb')
    
    context = Kernel.eval(File.read(context_file))

    # Set up the loading path for the filesystem loader
    Cadenza::FilesystemLoader.template_paths.push(source_directory)
    
    # Ask the loader to compile every file ending in *.cadenza
    Dir.glob(File.join(source_directory, '*.cadenza')).each do | cadenza_file |
      file = File.basename(cadenza_file)
      protocol = Cadenza::FilesystemLoader.protocol_name
      Cadenza::Loader.get_template(protocol, file)  
    end
    
    # Now render every loaded template to a file
    Cadenza::Loader.loaded_templates.each do | key, template |
      protocol, filename = key
      
      filename.gsub!(/\.cadenza$/,".html")
      
      ofstream = File.open(File.join(output_directory, filename), 'w') rescue next
      
      template.render(context, ofstream)
      
      ofstream.close
    end
  end

end
