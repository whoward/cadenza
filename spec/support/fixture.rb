
# frozen_string_literal: true

module Fixture
  module_function

  def filename(file)
    File.expand_path(File.join('..', 'fixtures', file), File.dirname(__FILE__))
  end

  def open(file)
    File.open(filename(file))
  end

  def read(file)
    File.read(filename(file))
  end
end
