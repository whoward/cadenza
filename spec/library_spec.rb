require 'spec_helper'

describe Cadenza::Library do
   subject { Cadenza::Library }

   let(:library) { mod = Module.new; mod.extend(subject); mod }

   let(:standard_library) do
      subject.build do
         define_filter(:foo) {}
         define_block(:foo) {}
         define_functional_variable(:foo) {}
      end
   end

   context "extension" do
      it "extends the module with Cadenza::Library::Filters" do
         library.should be_a Cadenza::Library::Filters
      end

      it "extends the module with Cadenza::Library::Blocks" do
         library.should be_a Cadenza::Library::Blocks
      end

      it "extends the module with Cadenza::Library::FunctionalVariables" do
         library.should be_a Cadenza::Library::FunctionalVariables
      end
   end

   context "inclusion" do
      it "copies all defined filters into the included class" do
         library.should have(0).filters
         library.send(:include, standard_library)
         library.should have(1).filters
      end

      it "copies all defined blocks into the included class" do
         library.should have(0).blocks
         library.send(:include, standard_library)
         library.should have(1).blocks
      end

      it "copies all defined functions into the included class" do
         library.should have(0).functional_variables
         library.send(:include, standard_library)
         library.should have(1).functional_variables
      end
   end

   context "inheritance" do
      let(:superclass) do
         klass = Class.new
         klass.extend(subject)
         klass.send(:include, standard_library)
         klass.define_filter(:bar) {}
         klass.define_block(:bar) {}
         klass.define_functional_variable(:bar) {}
         klass
      end

      let(:subclass) { Class.new(superclass) }

      it "has all the filters the superclass does" do
         subclass.should have(2).filters
      end

      it "has all the blocks the superclass does" do
         subclass.should have(2).blocks
      end

      it "has all the functions the superclass does" do
         subclass.should have(2).functional_variables
      end
   end

   context "#build" do
      it "returns a new module" do
         subject.build.should be_an_instance_of Module
      end

      it "extends the returned module by Library" do
         subject.build.should be_a Cadenza::Library
      end

      it "defines #enhance on the returned module" do
         subject.build.should respond_to :enhance
      end

      it "calls a passed block on it's own instance" do
         lib = subject.build do
            define_filter(:foo) {}
         end

         lib.filters[:foo].should_not be_nil
      end

      it "copies all filters, blocks and variables when enhancing an existing library" do
         extra_standard_library = standard_library.enhance do
            define_filter(:bar) {}
            define_block(:bar) {}
            define_functional_variable(:bar) {}
         end

         extra_standard_library.should have(2).filters
         extra_standard_library.should have(2).blocks
         extra_standard_library.should have(2).functional_variables
      end
   end
end