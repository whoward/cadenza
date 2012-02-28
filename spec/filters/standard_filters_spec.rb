require 'spec_helper'

describe Cadenza::BaseContext, 'standard filters' do
   subject { Cadenza::BaseContext }

   context "addslashes" do
      it "should replace slashes with double slashes" do
         subject.evaluate_filter(:addslashes, ["foo\\bar"]).should == "foo\\\\bar"
      end

      it "should escape single quotes" do
         subject.evaluate_filter(:addslashes, ["I'm here"]).should == "I\\'m here"
      end

      it "should escape double quotes" do
         subject.evaluate_filter(:addslashes, ["he said \"hello world!\""]).should == 'he said \\"hello world!\\"'
      end
   end

   context "capitalize" do
      it "should define the capitalize filter" do
         subject.evaluate_filter(:capitalize, ["foo"]).should == "Foo"
      end
   end

   context "center" do
      it "should center the text with spaces" do
         subject.evaluate_filter(:center, ["foo", 9]).should == "   foo   "
      end

      it "should have an optional argument for the padding character" do
         subject.evaluate_filter(:center, ["foo", 9, "x"]).should == "xxxfooxxx"
      end
   end

   context "cut" do
      it "should remove the string from the string" do
         subject.evaluate_filter(:cut, ["abcdefghi", "def"]).should == "abcghi"
      end
   end

   context "date" do
      let(:time) { Time.at(0).utc }

      it "should format the date using sprintf notation" do
         subject.evaluate_filter(:date, [time]).should == "1970-01-01"
      end

      it "should allow passing a custom string fomrmatting time" do
         subject.evaluate_filter(:date, [time, "%F %R"]).should == "1970-01-01 00:00"
      end
   end

   context "default" do
      it "should return the value if the value is some object" do
         subject.evaluate_filter(:default, ["foo", "default"]).should == "foo"
      end

      it "should return the default value if the value is nil" do
         subject.evaluate_filter(:default, [nil, "default"]).should == "default"
      end

      it "should return the default value if the value is an empty string" do
         subject.evaluate_filter(:default, ["", "default"]).should == "default"
      end

      it "should return the default value if the value is an empty array" do
         subject.evaluate_filter(:default, [[], "default"]).should == "default"
      end
   end

   context "escape" do
      it "should convert < and > to &lt; and &gt;" do
         subject.evaluate_filter(:escape, ["<br>"]).should == "&lt;br&gt;"
      end

      it "should convert & to &amp;" do
         subject.evaluate_filter(:escape, ["foo & bar"]).should == "foo &amp; bar"
      end
   end

   context 'first' do
      it "should return the first element of an iterable" do
         subject.evaluate_filter(:first, ["abc"]).should == "a"
         subject.evaluate_filter(:first, [%w(def ghi jkl)]).should == "def"
      end
   end

   context "last" do
      it "should return the last element of an iterable" do
         subject.evaluate_filter(:last, ["abc"]).should == "c"
         subject.evaluate_filter(:last, [%w(def ghi jkl)]).should == "jkl"
      end
   end

   context "join" do
      it "should return a string glued with the specified glue" do
         subject.evaluate_filter(:join, [[1,2,3], ", "]).should == "1, 2, 3"
      end
   end

   context "length" do
      it "should return the length of the object" do
         subject.evaluate_filter(:length, ["abc"]).should == 3
         subject.evaluate_filter(:length, [%w(a b c d e f)]).should == 6
      end
   end

   context "ljust" do
      it "should return the string left justified by the given length" do
         subject.evaluate_filter(:ljust, ["abc", 10]).should == "abc       "
      end

      it "should allow passing in a padding character" do
         subject.evaluate_filter(:ljust, ["abc", 10, 'x']).should == "abcxxxxxxx"
      end
   end

   context "rjust" do
      it "should return the string right justified by the given length" do
         subject.evaluate_filter(:rjust, ["abc", 10]).should == "       abc"
      end

      it "should allow passing in a padding character" do
         subject.evaluate_filter(:rjust, ["abc", 10, "x"]).should == "xxxxxxxabc"
      end
   end

   context "lower" do
      it "should downcase all characters" do
         subject.evaluate_filter(:lower, ["AbC"]).should == "abc"
      end
   end

   context "upper" do
      it "should upcase all characters" do
         subject.evaluate_filter(:upper, ["abc"]).should == "ABC"
      end
   end

   context "wordwrap" do
      it "should return the string with the words wrapped at the given column" do
         wrapped = subject.evaluate_filter(:wordwrap, ["This text is not too short to be wrapped.", 20])

         wrapped.should == "This text is not too\nshort to be wrapped.\n"
      end

      it "should allow specifying the character(s) used for line endings" do
         wrapped = subject.evaluate_filter(:wordwrap, ["This text is not too short to be wrapped.", 20, "<br/>"])

         wrapped.should == "This text is not too<br/>short to be wrapped.<br/>"
      end
   end
end
