# frozen_string_literal: true

require 'rubygems'
require 'rake'

# require every *.rake file inside of the tasks subdirectory
Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')].each { |f| load f }

task default: :spec
