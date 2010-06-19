
namespace :compile do
  
  desc "compile everything"
  task :all => [:parser]
  
  desc "compile the grammar file (cadenza.y) to a racc parser"
  task :parser do
    basedir = File.dirname(__FILE__)
    srcfile = File.join(basedir, '..', 'src', 'cadenza.y')
    outfile = File.join(basedir, '..', 'lib', 'parser.rb')
    
    system "racc -o #{outfile} #{srcfile}"
  end
  
end