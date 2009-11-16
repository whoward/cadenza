require 'spec/rake/spectask'

desc "Run the Cadenza specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov_opts = ['--options', "spec/rcov.opts"]
  t.verbose = true
end