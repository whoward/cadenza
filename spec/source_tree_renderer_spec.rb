require 'spec_helper'

describe Cadenza::SourceTreeRenderer do
   let(:output)   { StringIO.new }
   let(:renderer) { Cadenza::SourceTreeRenderer.new(output, :error_handler => lambda {|e| raise e }) }
   let(:context)  { Cadenza::Context.new }

   def render(document)
      output.reopen
      renderer.render(document, context)
      result = renderer.output.string
   end

   # replace easy ascii characters with their UTF drawing character equivalents
   def treeify(string)
      string.gsub("-", "\u2501").gsub("`", "\u2516").gsub("+", "\u2523").gsub("|", "\u2503")
   end

   context "constant nodes" do
      it "renders constants as Constant(\"value\")" do
         render(Cadenza::ConstantNode.new("abc")).should == %q{Constant("abc")}
         render(Cadenza::ConstantNode.new(123)).should == "Constant(123)"
         render(Cadenza::ConstantNode.new(123.45)).should == "Constant(123.45)"
      end
   end

   context "variable nodes" do
      it "renders variables as Variable(x)" do
         render(Cadenza::VariableNode.new("x")).should == "Variable(x)"
      end

      it "renders parameters as Variable(x[a, b, c])" do
         a = Cadenza::VariableNode.new("a")
         b = Cadenza::ConstantNode.new(123)
         c = Cadenza::ConstantNode.new("foo")

         node = Cadenza::VariableNode.new("x", [a, b, c])

         render(node).should == %q{Variable(x[Variable(a), Constant(123), Constant("foo")])}
      end
   end

   context "text nodes" do
      it "renders text as Text(\"abc\\n123\")" do
         render(Cadenza::TextNode.new("abc\n123")).should == %q{Text("abc\n123")}
      end
   end

   context "filter nodes" do
      it "renders the node" do
         render(Cadenza::FilterNode.new("escape")).should == "Filter(escape)"
      end

      it "renders parameters to the filter" do
         five = Cadenza::ConstantNode.new(5)
         three = Cadenza::ConstantNode.new(3)
         node = Cadenza::FilterNode.new("cut", [five, three])
         render(node).should == "Filter(cut[Constant(5), Constant(3)])"
      end
   end

   context "document nodes" do
      it "renders the document node and it's children on separate lines" do
         text = Cadenza::TextNode.new("abc")
         variable = Cadenza::VariableNode.new("x")

         node = Cadenza::DocumentNode.new([text, variable])

         expected = "Document\n" +
                    "+---Text(\"abc\")\n" +
                    "`---Variable(x)"

         render(node).should == treeify(expected)
      end

      it "renders the extends name" do
         text = Cadenza::TextNode.new("abc")
         variable = Cadenza::VariableNode.new("x")

         node = Cadenza::DocumentNode.new([text, variable])
         node.extends = "foo"

         expected = "Document(extends: foo)\n" +
                    "+---Text(\"abc\")\n" +
                    "`---Variable(x)"

         render(node).should == treeify(expected)
      end
   end

   context "operation nodes" do
      it "renders Operation(*) and it's children on separate lines" do
         text = Cadenza::TextNode.new("abc")
         variable = Cadenza::VariableNode.new("x")

         expected = "Operation(*)\n" +
                    "+---Text(\"abc\")\n" +
                    "`---Variable(x)"

         render(Cadenza::OperationNode.new(text, "*", variable)).should == treeify(expected)
      end
   end

   context "if nodes" do
      let(:expr) { Cadenza::VariableNode.new("x") }
      let(:yes)  { Cadenza::TextNode.new("yes") }
      let(:no)   { Cadenza::TextNode.new("no") }
      it "renders the node with the expression and both blocks on separate lines" do
         expected = "If\n"+
                    "| Expression:\n" +
                    "`---Variable(x)\n" +
                    "| True Block:\n" +
                    "`---Text(\"yes\")\n" +
                    "| False Block:\n" +
                    "`---Text(\"no\")"

         render(Cadenza::IfNode.new(expr, [yes], [no])).should == treeify(expected)
      end

      it "doesn't render the true block if it is empty" do
         expected = "If\n"+
                    "| Expression:\n" +
                    "`---Variable(x)\n" +
                    "| False Block:\n" +
                    "`---Text(\"no\")"

         render(Cadenza::IfNode.new(expr, [], [no])).should == treeify(expected)
      end

      it "doesn't render the false block if it is empty" do
         expected = "If\n"+
                    "| Expression:\n" +
                    "`---Variable(x)\n" +
                    "| True Block:\n" +
                    "`---Text(\"yes\")"

         render(Cadenza::IfNode.new(expr, [yes], [])).should == treeify(expected)
      end
   end

   context "for nodes" do
      it "renders the node with it's iterator and iterable and all the children objects" do
         text = Cadenza::TextNode.new("foo")
         iterator = Cadenza::VariableNode.new("i")
         iterable = Cadenza::VariableNode.new("elements")

         node = Cadenza::ForNode.new(iterator, iterable, [text])

         expected = "For(iterator: i, iterable: elements)\n"+
                    "`---Text(\"foo\")"

         render(node).should == treeify(expected)
      end
   end

   context "generic block nodes" do
      it "renders the node and it's children" do
         text = Cadenza::TextNode.new("<h1>hello!</h1>")
         node = Cadenza::GenericBlockNode.new("escape", [text])

         expected = "GenericBlock(escape)\n"+
                    "`---Text(\"<h1>hello!</h1>\")"

         render(node).should == treeify(expected)
      end

      it "renders parameters to the block" do
         text = Cadenza::TextNode.new("<h1>hello!</h1>")
         var  = Cadenza::VariableNode.new("escape")
         num  = Cadenza::ConstantNode.new(123)
         node = Cadenza::GenericBlockNode.new("filter", [text], [var, num])

         expected = "GenericBlock(filter[Variable(escape), Constant(123)])\n"+
                    "`---Text(\"<h1>hello!</h1>\")"

         render(node).should == treeify(expected)
      end
   end

   context "filtered value nodes" do
      it "renders the node and it's value as a child" do
         filter_a = Cadenza::FilterNode.new("escape")
         filter_b = Cadenza::FilterNode.new("cut", [Cadenza::ConstantNode.new(3)])

         value = Cadenza::VariableNode.new("x")

         node = Cadenza::FilteredValueNode.new(value, [filter_a, filter_b])

         expected = "FilteredValue[Filter(escape), Filter(cut[Constant(3)])]\n"+
                    "`---Variable(x)"

         render(node).should == treeify(expected)
      end
   end

   context "boolean inverse nodes" do
      it "renders the node and it's value as a child" do
         variable = Cadenza::VariableNode.new("x")
         node = Cadenza::BooleanInverseNode.new(variable)

         expected = "BooleanInverse\n"+
                    "`---Variable(x)"

         render(node).should == treeify(expected)
      end
   end

   context "block nodes" do
      it "renders the block and it's children" do
         hello = Cadenza::TextNode.new("<h1>Hello World!</h1>")
         node = Cadenza::BlockNode.new("content", [hello])

         expected = "Block(content)\n"+
                    "`---Text(\"<h1>Hello World!</h1>\")"

         render(node).should == treeify(expected)
      end
   end

   context "nesting" do
      it "renders multiple levels of children correctly" do
         ast = Cadenza::Parser.new.parse("{% for x in y %}{{ x }}{% endfor %}<h1>Total Items: {{ y | length }}</h1>")

         expected = "Document\n" +
                    "+---For(iterator: x, iterable: y)\n"+
                    "|   `---Variable(x)\n" +
                    "+---Text(\"<h1>Total Items: \")\n" +
                    "+---FilteredValue[Filter(length)]\n" +
                    "|   `---Variable(y)\n" +
                    "`---Text(\"</h1>\")"

         render(ast).should == treeify(expected)
      end
   end

end
