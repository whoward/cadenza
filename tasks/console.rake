desc "starts a irb console with cadenza preloaded"
task :console do
  system "irb -r #{File.dirname(__FILE__)}/../init.rb"
end
