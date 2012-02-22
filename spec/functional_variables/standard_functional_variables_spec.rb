require 'spec_helper'

describe Cadenza::BaseContext, 'standard functional variables' do
   subject { Cadenza::BaseContext }

   before { subject.add_loader Cadenza::FilesystemLoader.new(fixture_filename "templates") }
   after  { subject.clear_loaders }

   context "load" do
      it "should return the source of the given file without parsing it" do
         subject.evaluate_functional_variable(:load, ["index.html.cadenza"]).should == File.read(fixture_filename "templates/index.html.cadenza")
      end

      it "should return nil if the given file does not exist" do
         subject.evaluate_functional_variable(:load, ["fake.html"]).should be_nil
      end
   end

   context "render" do
      before { subject.push :pi => "def" }
      after  { subject.pop }

      it "should return the rendered content of the given file" do
         subject.evaluate_functional_variable(:render, ["test.html.cadenza"]).should == "abcdefghi"
      end

      it "should return empty text if the template does not exist" do
         subject.evaluate_functional_variable(:render, ["fake.html"]).should == ""
      end
   end
end