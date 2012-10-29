
class TestContextObject < Cadenza::ContextObject
   def public_method
      123
   end

protected
   def protected_method
      123
   end

private
   def before_method(method)
   end

   def after_method(method)
   end

   def missing_context_method(method)
   end

   def private_method
      123
   end
end
