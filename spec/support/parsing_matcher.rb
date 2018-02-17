
# frozen_string_literal: true

module ParsingMatcher
  def expect_parsing(template, options = {})
    parser = options.fetch(:with, Cadenza::Parser.new)

    expect parser.parse(template)
  end
end

RSpec.configure do |config|
  config.include ParsingMatcher
end
