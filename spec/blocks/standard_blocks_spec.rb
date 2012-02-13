require 'spec_helper'

describe Cadenza::BaseContext, 'standard blocks' do
   subject { Cadenza::BaseContext }

   context "filter" do
      it "should render the children to text and html escape the result" do
         text = Cadenza::TextNode.new("<h1>Hello World!</h1>")
         escape = Cadenza::VariableNode.new("escape")

         subject.evaluate_block(:filter, [text], [escape]).should == "&lt;h1&gt;Hello World!&lt;/h1&gt;"
      end
   end
end