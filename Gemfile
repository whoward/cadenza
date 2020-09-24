# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

group :test do
  gem 'nokogiri', '>= 1.10.8'
  gem 'nokogiri-diff', '~> 0.2.0'
  gem 'rspec', '~> 3.4.0'
end

group :development do
  gem 'racc', '~> 1.4.6' if RUBY_PLATFORM != 'java'
  gem 'rake'
  gem 'yard'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'rubocop', '0.52.1'
end
