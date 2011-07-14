desc "starts an irb console with the library loaded"
task :console do
  system "irb -r #{File.expand_path("../lib/cadenza", File.dirname(__FILE__))}"
end