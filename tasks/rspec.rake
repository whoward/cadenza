require 'rspec/core/rake_task'

desc "Run the Cadenza test suite"
RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
  t.rspec_opts = ['--options', "spec/spec.opts"]
end