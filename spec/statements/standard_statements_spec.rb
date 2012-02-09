require 'spec_helper'

describe Cadenza::BaseContext, 'standard statements' do
   subject { Cadenza::BaseContext }

   before { subject.add_loader Cadenza::FilesystemLoader.new(fixture_filename "templates") }
   after  { subject.clear_loaders }

   context "load" do
      it "should return the source of the given file without parsing it" do
         subject.evaluate_statement(:load, ["index.html.cadenza"]).should == File.read(fixture_filename "templates/index.html.cadenza")
      end

      it "should return nil if the given file does not exist" do
         subject.evaluate_statement(:load, ["fake.html"]).should be_nil
      end
   end
end