
# frozen_string_literal: true

module Cadenza
  # BaseContext is the recommended context class for beginners - it includes the full standard library of Cadenza
  # filters, blocks and functions.
  class BaseContext < Context
    include Cadenza::StandardLibrary
  end
end
