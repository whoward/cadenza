require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::ForNode do
   it "should be equal to another node with the same iterator, iterable and children" do
      text = Cadenza::TextNode.new("foo")
      iterator = Cadenza::VariableNode.new("i")
      iterable = Cadenza::VariableNode.new("elements")

      for_a = Cadenza::ForNode.new(iterator, iterable, [text])
      for_b = Cadenza::ForNode.new(iterator, iterable, [text])

      for_a.should == for_b
   end

   it "should not equal another node with a different iterator" do
      text = Cadenza::TextNode.new("foo")
      iterator_a = Cadenza::VariableNode.new("i")
      iterator_b = Cadenza::VariableNode.new("x")
      iterable = Cadenza::VariableNode.new("elements")

      for_a = Cadenza::ForNode.new(iterator_a, iterable, [text])
      for_b = Cadenza::ForNode.new(iterator_b, iterable, [text])

      for_a.should_not == for_b
   end

   it 'should not equal another node with a different iterable' do
      text = Cadenza::TextNode.new("foo")
      iterator = Cadenza::VariableNode.new("i")
      iterable_a = Cadenza::VariableNode.new("elements")
      iterable_b = Cadenza::VariableNode.new("array")

      for_a = Cadenza::ForNode.new(iterator, iterable_a, [text])
      for_b = Cadenza::ForNode.new(iterator, iterable_b, [text])

      for_a.should_not == for_b
   end

   it 'should not equal another node with different children' do
      text_a = Cadenza::TextNode.new("foo")
      text_b = Cadenza::TextNode.new("bar")
      iterator = Cadenza::VariableNode.new("i")
      iterable = Cadenza::VariableNode.new("elements")

      for_a = Cadenza::ForNode.new(iterator, iterable, [text_a])
      for_b = Cadenza::ForNode.new(iterator, iterable, [text_b])

      for_a.should_not == for_b
   end

   context "implied globals" do
      let(:iterable) { Cadenza::VariableNode.new("bars") }
      let(:iterator) { Cadenza::VariableNode.new("foo") }

      it "should return the children's implied globals minus locals defined (the iterator)" do
         variable = Cadenza::VariableNode.new("waz")

         for_node = Cadenza::ForNode.new(iterator, iterable, [variable])

         for_node.implied_globals.should == %w(bars waz)
      end

      it "should not return the iterator if found in the children's implied globals" do
         for_node = Cadenza::ForNode.new(iterator, iterable, [iterator])

         for_node.implied_globals.should == %w(bars)
      end

      it "should not return magic locals assigned to the inner scope" do
         counter = Cadenza::VariableNode.new("forloop.counter")
         counter0 = Cadenza::VariableNode.new("forloop.counter0")
         first = Cadenza::VariableNode.new("forloop.first")
         last = Cadenza::VariableNode.new("forloop.last")

         for_node_a = Cadenza::ForNode.new(iterator, iterable, [counter])
         for_node_b = Cadenza::ForNode.new(iterator, iterable, [counter0])
         for_node_c = Cadenza::ForNode.new(iterator, iterable, [first])
         for_node_d = Cadenza::ForNode.new(iterator, iterable, [last])

         for_node_a.implied_globals.should == %w(bars)
         for_node_b.implied_globals.should == %w(bars)
         for_node_c.implied_globals.should == %w(bars)
         for_node_d.implied_globals.should == %w(bars)
      end

      it "should rewrite dot notations of the iterator in terms of the iterable's identifier" do
         dot_notation = Cadenza::VariableNode.new("foo.baz")

         for_node = Cadenza::ForNode.new(iterator, iterable, [dot_notation])

         for_node.implied_globals.should == %w(bars bars.baz)
      end
   end

end
