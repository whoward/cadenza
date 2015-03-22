# More info at https://github.com/guard/guard#readme

require 'rubygems'

# load cross-platform gems (without using bundler)

def suggested_load(gem)
   begin
      require(gem)
   rescue LoadError => e
      puts("for better guard support you should install the #{gem} gem")
   end
end

# OSX
if RUBY_PLATFORM =~ /darwin/i
   suggested_load "rb-fsevent"
   suggested_load "ruby_gntp"
end

# Linux
if RUBY_PLATFORM =~ /linux/i
   suggested_load "rb-inotify"
   suggested_load "libnotify"
end

# Windows
if RUBY_PLATFORM =~ /mswin32/i
   suggested_load "rb-fchange"
   suggested_load "win32console"
   suggested_load "rb-notifu"
end

guard 'rspec', cmd: 'rspec --color' do
  watch(%r{^spec/.+$}) { Dir.glob("spec/**/*_spec.rb") }
  watch(%r{^lib/.+}) { Dir.glob("spec/**/*_spec.rb") }
end

guard 'shell' do
   watch('src/cadenza.y') { puts `rake compile:parser` }
end
