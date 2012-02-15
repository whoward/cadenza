
namespace :doc do

  desc "compile the user manual for cadenza"
  task :manual do
    require File.expand_path(File.join("..", "lib", "cadenza"), File.dirname(__FILE__))

    # get some useful directories before we get started
    root_directory = File.expand_path("..", File.dirname(__FILE__))
    source_directory = File.join(root_directory, 'doc', 'src')
    output_directory = File.join(root_directory, 'doc', 'manual')
    
    # define any custom context definitions for the document
    Cadenza::BaseContext.instance_eval(File.read(File.join source_directory, "context.rb"))

    # Set up the loading path for the filesystem loader
    Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(source_directory)
    Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(File.join source_directory, "iframe")

    render = lambda do |filename|
      template_name = File.basename(filename, ".cadenza")

      indir = File.dirname(filename)
      outdir = indir.gsub(source_directory, output_directory)

      FileUtils.mkdir_p(outdir)

      output_file = File.expand_path("#{template_name}.html", outdir)

      puts "rendering #{filename} to #{output_file}"

      File.open(output_file, "w") do |file|
        file.write Cadenza.render(File.read(filename), {})
      end
    end
    
    # Compile all the cadenza files under the source directory
    Dir[File.join(source_directory, '*.cadenza')].each {|file| render.call(file) }
    
    Dir[File.join(source_directory, 'iframe', '*.cadenza')].each {|file| render.call(file) }
  end

end
