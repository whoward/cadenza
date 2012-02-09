
module Cadenza
   class TemplateNotFoundError < StandardError
   end

   class FilterNotDefinedError < StandardError
   end

   class StatementNotDefinedError < StandardError
   end

   class Context
      attr_accessor :stack, :filters, :statements, :loaders
      attr_accessor :whiny_template_loading

      def initialize(initial_scope={})
         @stack = []
         @filters = {}
         @statements = {}
         @loaders = []
         @whiny_template_loading = false

         push initial_scope
      end

      def clone
         copy = super
         copy.stack = stack.dup
         copy.loaders = loaders.dup
         copy.filters = filters.dup
         copy.statements = statements.dup

         copy
      end

      def lookup(identifier)
         @stack.reverse_each do |scope|
            value = lookup_identifier(scope, identifier)

            return value unless value.nil?
         end
         
         nil
      end

      def assign(identifier, value)
         @stack.last[identifier.to_sym] = value
      end

      # TODO: symbolizing strings is slow so consider symbolizing here to improve
      # the speed of the lookup method (its more important than push)
      def push(scope)
         @stack.push(scope)
      end

      def pop
         @stack.pop
      end

      def define_filter(name, &block)
         @filters[name.to_sym] = block
      end

      def evaluate_filter(name, params=[])
         filter = @filters[name.to_sym]
         raise FilterNotDefinedError.new("undefined filter '#{name}'") if filter.nil?
         filter.call(*params)
      end

      def define_statement(name, &block)
         @statements[name.to_sym] = block
      end

      def evaluate_statement(name, params=[])
         statement = @statements[name.to_sym]
         raise StatementNotDefinedError.new("undefined statement '#{name}'") if statement.nil?
         statement.call([self] + params)
      end

      def add_loader(loader)
         if loader.is_a?(String)
            @loaders.push FilesystemLoader.new(loader)
         else
            @loaders.push loader
         end
      end

      def clear_loaders
         @loaders.reject! { true }
      end

      def load_template(template_name)
         template = nil

         @loaders.each do |loader|
            template = loader.load_template(template_name)
            break if template
         end
         
         if template.nil? and whiny_template_loading
            raise TemplateNotFoundError.new(template_name)
         else
            return template
         end
      end

      def load_template!(template_name)
         template = load_template(template_name)

         if template
            return template
         else
            raise TemplateNotFoundError.new(template_name)
         end
      end

   private
      def lookup_identifier(scope, identifier)
         if identifier.index('.')
            lookup_path(scope, identifier.split("."))
         else
            lookup_on_scope(scope, identifier)
         end
      end

      def lookup_path(scope, path)
         loop do
            component = path.shift

            scope = lookup_on_scope(scope, component)

            return scope if path.empty?
         end
      end

      def lookup_on_scope(scope, identifier)
         sym_identifier = identifier.to_sym

         # allow looking up array indexes with dot notation, example: alphabet.0 => "a"
         if scope.respond_to?(:[]) and scope.is_a?(Array) and identifier =~ /\d+/
            return scope[identifier.to_i]
         end

         # otherwise if it's a hash look up the string or symbolized key
         if scope.respond_to?(:[]) and scope.is_a?(Hash) and (scope.has_key?(identifier) || scope.has_key?(sym_identifier))
            return scope[identifier] || scope[sym_identifier]
         end

         # if the identifier is a callable method then call that
         return scope.send(sym_identifier) if scope.respond_to?(sym_identifier)

         nil
      end

   end

end