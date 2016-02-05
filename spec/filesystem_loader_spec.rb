require 'spec_helper'

describe Cadenza::FilesystemLoader do
  let(:loader) { Cadenza::FilesystemLoader.new(Fixture.filename('templates')) }

  context '#load_template' do
    it 'should return the parsed template tree if the file exists' do
      template = loader.load_template('test.html.cadenza')

      expect(template).not_to be_nil
      expect(template).to equal_syntax_tree 'templates/test.parse.yml'
    end
  end

  context '#load_source' do
    it 'should return the source if the file is a file symlink' do
      expect(loader.load_source('test.html.cadenza')).to eq(Fixture.read('templates/test.html.cadenza'))
    end

    it 'should return nil if the file does not exist' do
      expect(loader.load_source('fake.html.cadenza')).to be_nil
    end

    it 'should return nil if the file is a directory' do
      expect(loader.load_source('test-directory')).to be_nil
    end

    it 'should return nil if the file is a directory symlink' do
      expect(loader.load_source('test-directory-symlink')).to be_nil
    end

    it 'should return the source if the file is a file symlink' do
      expect(loader.load_source('test-file-symlink')).to eq(Fixture.read('templates/test.html.cadenza'))
    end

    it 'should return the parsed template tree if the file is in a subdirectory' do
      expect(loader.load_source('test-directory/test.html.cadenza')).to eq(Fixture.read('templates/test-directory/test.html.cadenza'))
    end
  end
end
