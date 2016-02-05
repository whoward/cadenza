require 'spec_helper'

describe Cadenza::FilesystemLoader do
  let(:loader) { Cadenza::FilesystemLoader.new(Fixture.filename('templates')) }

  context '#load_template' do
    it 'should return the parsed template tree if the file exists' do
      template = loader.load_template('test.html.cadenza')

      template.should_not be_nil
      template.should equal_syntax_tree 'templates/test.parse.yml'
    end
  end

  context '#load_source' do
    it 'should return the source if the file is a file symlink' do
      loader.load_source('test.html.cadenza').should == Fixture.read('templates/test.html.cadenza')
    end

    it 'should return nil if the file does not exist' do
      loader.load_source('fake.html.cadenza').should be_nil
    end

    it 'should return nil if the file is a directory' do
      loader.load_source('test-directory').should be_nil
    end

    it 'should return nil if the file is a directory symlink' do
      loader.load_source('test-directory-symlink').should be_nil
    end

    it 'should return the source if the file is a file symlink' do
      loader.load_source('test-file-symlink').should == Fixture.read('templates/test.html.cadenza')
    end

    it 'should return the parsed template tree if the file is in a subdirectory' do
      loader.load_source('test-directory/test.html.cadenza').should == Fixture.read('templates/test-directory/test.html.cadenza')
    end
  end
end
