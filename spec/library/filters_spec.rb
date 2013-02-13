require 'spec_helper'

describe Cadenza::Library::Filters do
   let(:library) do
      Cadenza::Library.build do
         define_filter(:pluralize) {|input, params| "#{input}s" }
      end
   end

   context "#define_filter" do
      it "should allow defining a filter method" do
         library.filters[:pluralize].should be_a(Proc)
      end

      it "should evaluate a filter" do         
         library.evaluate_filter(:pluralize, "bar").should == "bars"
      end

      it "should raise a FilterNotDefinedError if the filter is not defined" do
         lambda do
            library.evaluate_filter(:foo, "bar")
         end.should raise_error Cadenza::FilterNotDefinedError
      end
   end

   context "#lookup_filter" do
      it "returns the given filter" do
         library.lookup_filter(:pluralize).should be_a Proc
      end

      it "raises a FilterNotDefinedError if the block is not defined" do
         lambda do
            library.lookup_filter(:fake)
         end.should raise_error Cadenza::FilterNotDefinedError
      end
   end

   context "#alias_filter" do
      it "returns nil" do
         library.alias_filter(:pluralize, :pluralizar).should be_nil
      end

      it "duplicates the filter block under a different name" do
         library.alias_filter(:pluralize, :pluralizar) # alias it as the spanish form of pluralize

         library.evaluate_filter(:pluralizar, "bar").should == "bars"
      end

      it "raises a FilterNotDefinedError if the source filter is not defined" do
         lambda do
            library.alias_filter(:fake, :something)
         end.should raise_error Cadenza::FilterNotDefinedError
      end
   end
end