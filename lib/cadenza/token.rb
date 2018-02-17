
# frozen_string_literal: true

module Cadenza
  # TODO: make helpers for building tokens
  Token = Struct.new(:value, :source, :line, :column)
end
