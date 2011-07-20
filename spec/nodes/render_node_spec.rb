require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::RenderNode do

   it "should equal a node with the same value" do
      render_a = Cadenza::RenderNode.new("somefile.cadenza")
      render_b = Cadenza::RenderNode.new("somefile.cadenza")

      render_a.should == render_b
   end

   it "should not equal a node with a different value" do
      render_a = Cadenza::RenderNode.new("somefile.cadenza")
      render_b = Cadenza::RenderNode.new("otherfile.cadenza")

      render_a.should_not == render_b
   end

   it "should return an empty list for implied globals if it's filename is a string" do
      Cadenza::RenderNode.new("somefile.cadenza").implied_globals.should == []
   end

   it "should return a list of it's filename identifier if it's filename is a variable node" do
      variable = Cadenza::VariableNode.new("somefile")

      Cadenza::RenderNode.new(variable).implied_globals.should == %w(somefile)
   end

end