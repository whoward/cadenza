module Cadenza
  class ForNode
   attr_accessor :iterator, :iterable, :children
    
   MAGIC_LOCALS = %w(forloop.counter forloop.counter0 forloop.first forloop.last)

   def initialize(iterator, iterable, children)
      @iterator = iterator
      @iterable = iterable
      @children = children
   end

   def implied_globals
      iterable_globals = @iterable.implied_globals
      iterator_globals = @iterator.implied_globals

      iterator_regex = Regexp.new("^#{@iterator.identifier}[\.](.+)$")

      all_children_globals = @children.map(&:implied_globals).flatten

      children_globals = all_children_globals.reject {|x| x =~ iterator_regex }

      iterator_children_globals = all_children_globals.select {|x| x =~ iterator_regex }.map do |identifier|
         "#{iterable.identifier}.#{iterator_regex.match(identifier)[1]}"
      end

      (iterable_globals | children_globals | iterator_children_globals) - MAGIC_LOCALS - iterator_globals
   end

   def ==(rhs)
      @iterator == rhs.iterator and
      @iterable == rhs.iterable and
      @children == rhs.children
   end
    
  end
end