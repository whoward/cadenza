require 'cadenza/standard_library/filters'
require 'cadenza/standard_library/blocks'
require 'cadenza/standard_library/functional_variables'

module Cadenza
   module StandardLibrary
      extend Cadenza::Library

      include Cadenza::StandardLibrary::Filters
      include Cadenza::StandardLibrary::Blocks
      include Cadenza::StandardLibrary::FunctionalVariables
   end
end