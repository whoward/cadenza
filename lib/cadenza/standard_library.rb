require 'cadenza/standard_library/filters'
require 'cadenza/standard_library/blocks'
require 'cadenza/standard_library/functions'

module Cadenza
   module StandardLibrary
      extend Cadenza::Library

      include Cadenza::StandardLibrary::Filters
      include Cadenza::StandardLibrary::Blocks
      include Cadenza::StandardLibrary::Functions
   end
end