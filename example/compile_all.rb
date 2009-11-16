require '../init'

# if the launchy gem is installed inform the user that we will automatically launch the examples in the browser
begin
  require "rubygems"
  require "launchy"
  
#  use_launchy = true
  puts "Launch gem is installed, examples will automatically be opened in a web browser"
rescue LoadError
  use_launchy = false
  puts "Example pages weren't automatically opened in a browser, to do this install launchy gem: `gem install launchy`"
end

# This will be the context passed to EVERY example
context = {
  'alphabet' => ('A'..'Z').to_a,
  # old stuff
  'title'=>'This is a Cadenza Page!',
  'test_variable'=>true,
  'values'=>['one','two','three','four']
}

# Set up the loading path for the filesystem loader
Cadenza::FilesystemLoader.template_paths.push(File.dirname(__FILE__))

# Ask the loader to compile every file ending in *.cadenza
Dir.glob(File.join(File.dirname(__FILE__), '*.cadenza')).each do | cadenza_file |
  Cadenza::Loader.get_template(Cadenza::FilesystemLoader.protocol_name, cadenza_file)  
end

# Now render every loaded template to a file
Cadenza::Loader.loaded_templates.each do | key, template |
  protocol, filename = key
  
  filename.gsub!(".cadenza",".html")
  
  ofstream = File.open(filename, 'w') rescue next
  
  template.render(context, ofstream)
  
  ofstream.close
  
  Launchy::Browser.run(filename) if use_launchy
end
