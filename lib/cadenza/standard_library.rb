
module Cadenza
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
