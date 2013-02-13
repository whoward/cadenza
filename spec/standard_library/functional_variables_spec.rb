require 'spec_helper'

describe Cadenza::StandardLibrary::FunctionalVariables do
   subject { Cadenza::StandardLibrary }

   let(:context) { Cadenza::BaseContext.new }

   before { context.add_loader Cadenza::FilesystemLoader.new(fixture_filename "templates") }
   after  { context.clear_loaders }

   context "load" do
      it "should return the source of the given file without parsing it" do
         subject.evaluate_functional_variable(:load, context, ["index.html.cadenza"]).should == File.read(fixture_filename "templates/index.html.cadenza")
      end

      it "should return nil if the given file does not exist" do
         subject.evaluate_functional_variable(:load, context, ["fake.html"]).should be_nil
      end
   end

   context "render" do
      before { context.push :pi => "def" }
      after  { context.pop }

      it "should return the rendered content of the given file" do
         subject.evaluate_functional_variable(:render, context, ["test.html.cadenza"]).should == "abcdefghi"
      end

      it "should return empty text if the template does not exist" do
         subject.evaluate_functional_variable(:render, context, ["fake.html"]).should == ""
      end
   end
end