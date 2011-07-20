require 'spec_helper'

describe Cadenza::FilesystemLoader do
   let(:loader) { Cadenza::FilesystemLoader.new(fixture_filename "templates") }

   context "#load_template" do
      it "should return the parsed template tree if the file exists" do
         template = loader.load_template("test.html.cadenza")

         template.should_not be_nil
         template.should have_an_identical_syntax_tree_to "templates/test.parse.yml"
      end

      it "should return nil if the file does not exist" do
         loader.load_template("fake.html.cadenza").should be_nil
      end

      it "should return nil if the file is a directory" do
         loader.load_template("test-directory").should be_nil
      end

      it "should return nil if the file is a directory symlink" do
         loader.load_template("test-directory-symlink").should be_nil
      end

      it "should return the parsed template tree if the file is a file symlink" do
         template = loader.load_template("test-file-symlink")

         template.should_not be_nil
         template.should have_an_identical_syntax_tree_to "templates/test.parse.yml"
      end

      it "should return nil if the file exists but is not in a subtree of the path" do
         loader.load_template("../empty.parse.yml").should be_nil
      end

      it "should return the parsed template tree if the file is in a subdirectory" do
         template = loader.load_template("test-directory/test.html.cadenza")

         template.should_not be_nil
         template.should have_an_identical_syntax_tree_to "templates/test-directory/test.parse.yml"
      end

   end
end