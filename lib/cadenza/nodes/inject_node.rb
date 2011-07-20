module Cadenza
  class InjectNode
    attr_accessor :value, :filters
    
    def initialize(value, filters=[])
      @value = value
      @filters = filters
    end

    def ==(rhs)
      self.value == rhs.value and
      self.filters == rhs.filters
    end

    def implied_globals
      (@value.implied_globals + @filters.map(&:implied_globals).flatten).uniq
    end

    def evaluate(context)
      value = @value.eval(context)

      @filters.each {|filter| value = filter.evaluate(context, value) }

      value
    end
  end
end