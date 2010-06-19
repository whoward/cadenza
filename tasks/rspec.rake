begin
  require 'spec/rake/spectask'
  
  desc "Run the Cadenza test suite"
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ['--options', "spec/spec.opts"]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov_opts = ['--options', "spec/rcov.opts"]
    t.verbose = true
  end
  
rescue LoadError => e
  puts "RSpec does not appear to be installed, test suite tasks will not be shown"
end