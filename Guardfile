# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :cli => "--color" do
  watch(%r{^spec/.+$}) { Dir.glob("spec/**/*_spec.rb") }
  watch(%r{^lib/.+}) { Dir.glob("spec/**/*_spec.rb") }
end

guard 'shell' do
   watch('src/cadenza.y') { puts `rake compile:parser` }
end