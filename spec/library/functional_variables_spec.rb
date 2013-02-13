require 'spec_helper'

describe Cadenza::Library::FunctionalVariables do
   let(:library) do
      Cadenza::Library.build do
         define_functional_variable(:assign) {|context, name, value| context.assign(name, value) }
      end
   end

   let(:context) { Cadenza::Context.new }

   context "#define_functional_variable" do
      it "should allow defining a functional variable" do
         library.functional_variables[:assign].should be_a(Proc)
      end

      it "should evaluate a functional variable" do
         context.lookup("foo").should be_nil
         
         library.evaluate_functional_variable(:assign, context, ["foo", 123])

         context.lookup("foo").should == 123
      end

      it "should raise a FunctionalVariableNotDefinedError if the functional variable is not defined" do
         lambda do
            library.evaluate_functional_variable(:foo, [])
         end.should raise_error Cadenza::FunctionalVariableNotDefinedError
      end
   end
   
   context "#lookup_functional_variable" do
      it "returns the given functional variable" do
         library.lookup_functional_variable(:assign).should be_a Proc
      end

      it "raises a FunctionalVariableNotDefinedError if the block is not defined" do
         lambda do
            library.lookup_functional_variable(:fake)
         end.should raise_error Cadenza::FunctionalVariableNotDefinedError
      end
   end

   context "#alias_functional_variable" do
      it "returns nil" do
         library.alias_functional_variable(:assign, :set).should be_nil
      end

      it "duplicates the variable block under a different name" do
         library.alias_functional_variable(:assign, :set)

         library.evaluate_functional_variable(:set, context, ["foo", 123])

         context.lookup("foo").should == 123
      end

      it "raises a FunctionalVariableNotDefinedError if the source variable is not defined" do
         lambda do
            library.alias_functional_variable(:fake, :something)
         end.should raise_error Cadenza::FunctionalVariableNotDefinedError
      end
   end
end