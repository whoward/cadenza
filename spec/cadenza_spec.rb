require 'spec_helper'

describe Cadenza do
   before do
      Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(fixture_filename "templates")
   end

   after do
      Cadenza::BaseContext.clear_loaders
   end

   it "should define a base context" do
      Cadenza::BaseContext.should be_a Cadenza::Context
   end

   it "should define a simple render function which will use the base context to render a string" do
      template = File.read(fixture_filename "templates/index.html.cadenza")
      expected = File.read(fixture_filename "templates/index.html")

      Cadenza.render(template).should be_html_equivalent_to expected
   end

   it "should allow passing a scope" do
      template = File.read(fixture_filename "templates/test.html.cadenza")

      Cadenza.render(template, :pi => 3.14159).should == "abc3.14159ghi"
      Cadenza.render(template, :pi => "def").should == "abcdefghi"
   end

   it "should define a render function to load a template off the context's load system and render a string" do
      expected = File.read(fixture_filename "templates/index.html")

      Cadenza.render_template("index.html.cadenza").should be_html_equivalent_to expected
   end

   it "should allow passing a scope" do
      Cadenza.render_template("test.html.cadenza", :pi => 3.14159).should == "abc3.14159ghi"
      Cadenza.render_template("test.html.cadenza", :pi => "foo").should == "abcfooghi"
   end
end