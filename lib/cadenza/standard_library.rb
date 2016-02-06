
module Cadenza\
  # The Standard Library is a collection of all the standard filters, block and functions defined in Cadenza
  module StandardLibrary
    extend Cadenza::Library

    require 'cadenza/standard_library/filters'
    require 'cadenza/standard_library/blocks'
    require 'cadenza/standard_library/functions'

    include Filters
    include Blocks
    include Functions
  end
end
