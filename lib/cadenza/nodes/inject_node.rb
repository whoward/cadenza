module Cadenza
  class InjectNode
    attr_accessor :value, :filters, :parameters
    
    def initialize(value, filters=[], parameters=[])
      @value = value
      @filters = filters
      @parameters = parameters
    end

    def ==(rhs)
      self.value == rhs.value and
      self.filters == rhs.filters and
      self.parameters == rhs.parameters
    end

    def implied_globals
      (@value.implied_globals + @filters.map(&:implied_globals).flatten).uniq
    end

    def evaluate(context)
      value = @value.eval(context)

      if value.is_a? Proc
        args = parameters.map {|p| p.eval(context) }
        value = value.call(context, *args)
      end

      @filters.each {|filter| value = filter.evaluate(context, value) }

      value
    end
  end
end