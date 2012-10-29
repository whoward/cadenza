
module Cadenza
   class ContextObject < Object # intentionally declared, since we cannot 
                                # subclass BasicObject in 1.8.7

   private
      def before_method(method)
         # no implementation, used by subclasses
      end

      def after_method(method)
         # no implementation, used by subclasses
      end

      def missing_context_method(method)
         # no implementation, used by subclasses
      end

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

      def context_methods
         self.class.public_instance_methods.map(&:to_s)
      end
      
   end
end