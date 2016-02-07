source 'https://rubygems.org'
gemspec

group :test do
  gem 'rspec', '~> 3.4.0'
  gem 'nokogiri-diff', '~> 0.2.0'
  gem 'nokogiri', '~> 1.5.0'
end

group :development do
  gem 'rake'
  gem 'racc', '~> 1.4.6' if RUBY_PLATFORM != 'java'
  gem 'yard'
end

group :development, :test do
  gem 'coveralls', require: false
  gem 'rubocop', '0.37.0'
end
