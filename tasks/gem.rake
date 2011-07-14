
namespace :gem do
  desc "builds the gem"
  task :build do
    `gem build cadenza.gemspec`
  end

  desc "builds and installs the gem into your local rubygems"
  task :install => [:build] do
    `gem install cadenza-#{Cadenza::Version::STRING}.gem`

    Rake::Task["build:clean"].invoke
  end

  task :clean do
    system "rm cadenza-#{Cadenza::Version::STRING}.gem"
  end
end