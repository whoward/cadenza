source "https://rubygems.org"
gemspec

group :test do
   gem 'rspec', '~> 2.6.0'
   gem 'nokogiri-diff', "~> 0.2.0"
   gem 'nokogiri', '~> 1.5.0'
end

group :development do
   gem 'rake', '~> 0.9.2'
   gem 'racc', "~> 1.4.6" if RUBY_PLATFORM != "java"
   gem 'yard'
   gem 'guard-rspec'
   gem 'guard-shell'
end