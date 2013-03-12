require 'spec_helper'

describe Cadenza::StandardLibrary::Blocks do
   subject { Cadenza::StandardLibrary }

   context "filter" do
      let(:text) { Cadenza::TextNode.new("<h1>Hello World!</h1>") }
      let(:escape) { Cadenza::VariableNode.new("escape") }
      let(:context) { Cadenza::BaseContext.new }

      it "should render the children to text and html escape the result" do
         context.evaluate_block(:filter, [text], [escape]).should == "&lt;h1&gt;Hello World!&lt;/h1&gt;"
      end

      it "raises an error if there is not exactly 1 argument" do
         lambda do
            context.evaluate_block(:filter, [text], [])
         end.should raise_error Cadenza::InvalidArgumentCountError
      end

      it "raises an error if the first argument is not a variable" do
         lambda do
            context.evaluate_block(:filter, [text], [123])
         end.should raise_error Cadenza::InvalidArgumentTypeError
      end
   end
end