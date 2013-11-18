require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cadenza::Parser, 'block parsing' do

   it "should parse block blocks" do
      expect_parsing("{% block foo %}bar{% endblock %}").to equal_syntax_tree "block/basic.yml"
   end

   it "should parse a block with no content" do
      expect_parsing("{% block foo %}{% endblock %}").to equal_syntax_tree "block/empty.yml"
   end

   it "should prefix nested block names with their parent's name joined by a period" do
      template = "{% block parent %}{% block child %}{% endblock %}{% endblock %}"

      expect_parsing(template).to equal_syntax_tree "block/nested.yml"
   end
end