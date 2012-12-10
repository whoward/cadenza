
module Cadenza
   # ContextObject is a bare bones class which should become the superclass
   # of any object you wish to push onto the {Context::Stack#stack} of the 
   # context you render your template with.
   # 
   # Normal ruby objects (with the exception of Hash and Array) will not allow
   # any value to be looked up upon it when pushed onto the {Context::Stack#stack} 
   # unless they are subclasses of {ContextObject}.  See {Context.lookup_on_object} 
   # for specific details on how this is done.
   class ContextObject < Object # intentionally declared, since we cannot 
                                # subclass BasicObject in 1.8.7

   private
      # Callback method which is called before the given method name is called
      # by {#invoke_context_method}
      #
      # This method can be overridden by subclasses for whatever purpose they
      # wish, ex. statistics gathering
      # 
      # @note this method is a *private* method, but has been documented for
      #       your understanding.
      # @!visibility public
      # @param [String|Symbol] method the name of the method that was called
      def before_method(method)
         # no implementation, used by subclasses
      end

      # Callback method which is called after the given method name is called
      # by {#invoke_context_method}
      #
      # This method can be overridden by subclasses for whatever purpose they
      # wish, ex. statistics gathering
      # 
      # @note this method is a *private* method, but has been documented for
      #       your understanding.
      # @!visibility public
      # @param [String|Symbol] method the name of the method that was called
      def after_method(method)
         # no implementation, used by subclasses
      end

      # Method called by {#invoke_context_method} when the given method could
      # not be found in the class's public method list.
      #
      # The return value of this method is returned by {#invoke_context_method}
      # 
      # @note this method is a *private* method, but has been documented for
      #       your understanding.
      # @!visibility public
      # @param [String|Symbol] method the name of the method that was called
      def missing_context_method(method)
         # no implementation, used by subclasses
      end

      # Looks up and calls the given method on this object and returns it's 
      # value.
      #
      # Only methods in the public visibility scope (see {#context_methods}) can
      # be called by this method.
      #
      # If the method can not be found on this object then {#missing_context_method}
      # will be called instead.  You can use this to provide a "method_missing"
      # for your context object.
      #
      # Around the call to the method on this object the {#before_method} and
      # {#after_method} methods will be called with the name of the method.  You
      # may wish to use this to perform live benchmarking or other statistics
      # gathering.
      #
      # @note this method is a *private* method, but has been documented for
      #       your understanding.
      # @!visibility public
      # @param [Symbol|String] method the name of the method to call
      # @return [Object] the value returned from the method call
      def invoke_context_method(method)
         send(:before_method, method)
         
         if context_methods.include?(method.to_s)
            result = send(method)
         else
            result = send(:missing_context_method, method)
         end

         send(:after_method, method)

         result
      end

      # @note this method is a *private* method, but has been documented for
      #       your understanding.
      # @!visibility public
      # @return [Array] a list of methods which are in the public visibility 
      #         scope for this class
      def context_methods
         self.class.public_instance_methods.map(&:to_s)
      end
      
   end
end