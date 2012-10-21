# -*- encoding: utf-8 -*-
require File.expand_path("lib/cadenza/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = %q{cadenza}
  s.version = Cadenza::Version::STRING
  s.platform = Gem::Platform::RUBY

  s.authors = ["William Howard"]
  s.email = ["whoward.tke@gmail.com"]
  s.homepage = %q{http://github.com/whoward/Cadenza}

  s.summary = %q{Powerful text templating language similar to Smarty/Liquid/Django}

  s.require_paths = ["lib"]

  s.default_executable = %q{cadenza}
  s.executables = ["cadenza"]

  s.files = Dir.glob("lib/**/*.rb")
  s.test_files = Dir.glob("test/**/*.rb")

  s.add_development_dependency "rake", "~> 0.9.2"
  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "racc", "~> 1.4.6"
  s.add_development_dependency "nokogiri-diff", "~> 0.1.0"
  s.add_development_dependency "yard"

  # to make testing more fun (if only it needed less configuration)
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-shell"
end

