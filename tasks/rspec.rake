require 'rspec/core/rake_task'

desc "Run the Cadenza test suite"
RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
  t.rspec_opts = ['--options', "spec/spec.opts"]
end

namespace :spec do
  desc "Run the Cadenza test suite for lexer tests"
  RSpec::Core::RakeTask.new(:lexer) do |t|
    t.pattern = FileList["spec/lexer/**/*_spec.rb"]
    t.rspec_opts = ['--options', "spec/spec.opts"]
  end

  desc "Run the Cadenza test suite for parser tests"
  RSpec::Core::RakeTask.new(:parser) do |t|
    t.pattern = FileList["spec/parser/**/*_spec.rb"]
    t.rspec_opts = ['--options', "spec/spec.opts"]
  end

  desc "Run the Cadenza test suite for api tests"
  RSpec::Core::RakeTask.new(:api) do |t|
    t.pattern = FileList["spec/lexer/**/*_spec.rb"]
    t.rspec_opts = ['--options', "spec/spec.opts"]
  end
end