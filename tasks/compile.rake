
namespace :compile do
  
  desc "compile everything"
  task :all => [:parser]
  
  desc "compile the grammar file (cadenza.y) to a racc parser"
  task :parser do
    basedir = File.dirname(__FILE__)
    srcfile = File.expand_path(File.join('..', 'src', 'cadenza.y'), basedir)
    outfile = File.expand_path(File.join('..', 'lib', 'cadenza', 'parser.rb'), basedir)
    
    system "racc -o \"#{outfile}\" \"#{srcfile}\""

    puts "Regenerated parser from source file"
  end
  
end