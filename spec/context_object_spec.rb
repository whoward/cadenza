require 'spec_helper'

describe Cadenza::ContextObject do
   subject { Cadenza::ContextObject }

   it "should be instantiable" do
      lambda { subject.new }.should_not raise_error
   end

   # Cadenza::ContextObject is just a placeholder for now, it will be implemented
   # for Cadenza 0.8.0 as a replacement for general calling methods on objects
   # bounds to the context - binding an object in 0.8+ will pretty much do
   # nothing unless it is a subclass of Cadenza::ContextObject
   #
   # The reason for doing so is that we support Ruby 1.8.7 which does not
   # implement Object#public_send, and shoddy support for Object#respond_to?
   # (it will find protected methods), this probably won't be cleared up
   # until Ruby 2.0. (see: http://bugs.ruby-lang.org/issues/3562)
   #
   # In 1.8.7 however we can just use a diff of Object#public_instance_methods
   # to figure out just what was defined publicly on the object subclass.
   #
   # As a side effect we can enable metaprogramming and live benchmarking by
   # adding before/after filters to objects, you could imagine a class hierarchy
   # like this:
   #
   #    MyObject < BenchmarkingContextObject < Cadenza::ContextObject
   # 
   # where BenchmarkingContextObject would be responsible for collecting
   # statistics.
end