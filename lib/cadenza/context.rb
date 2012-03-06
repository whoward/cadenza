
module Cadenza
   class TemplateNotFoundError < StandardError
   end

   class FilterNotDefinedError < StandardError
   end

   class FunctionalVariableNotDefinedError < StandardError
   end

   class BlockNotDefinedError < StandardError
   end

   # The {Context} class is an essential class in Cadenza that contains all the
   # data necessary to render a template to it's output.  The context holds all
   # defined variable names (see {#stack}), {#filters}, {#functional_variables},
   # generic {#blocks}, {#loaders} and configuration data as well as all the 
   # methods you should need to define and evaluate those.
   class Context
      # @return [Array] the variable stack
      attr_accessor :stack

      # @return [Hash] the filter names mapped to their implementing procs
      attr_accessor :filters

      # @return [Hash] the functional variable names mapped to their implementing procs
      attr_accessor :functional_variables

      # @return [Hash] the block names mapped to their implementing procs
      attr_accessor :blocks

      # @return [Array] the list of loaders
      attr_accessor :loaders

      # @return [Boolean] true if a {TemplateNotFoundError} should still be
      #                   raised if not calling the bang form of {#load_source}
      #                   or {#load_template}
      attr_accessor :whiny_template_loading

      # creates a new context object with an empty stack, filter list, functional
      # variable list, block list, loaders list and default configuration options.
      #
      # When created you can push an optional scope onto as the initial stack
      #
      # @param [Hash] initial_scope the initial scope for the context
      def initialize(initial_scope={})
         @stack = []
         @filters = {}
         @functional_variables = {}
         @blocks = {}
         @loaders = []
         @whiny_template_loading = false

         push initial_scope
      end

      # creates a new instance of the context with the stack, loaders, filters,
      # functional variables and blocks shallow copied.
      #
      # @return [Context] the cloned context
      def clone
         copy = super
         copy.stack = stack.dup
         copy.loaders = loaders.dup
         copy.filters = filters.dup
         copy.functional_variables = functional_variables.dup
         copy.blocks = blocks.dup

         copy
      end

      # retrieves the value of the given identifier by inspecting the variable
      # stack from top to bottom.  Identifiers with dots in them are separated
      # on that dot character and looked up as a path.  If no value could be 
      # found then nil is returned.
      #
      # @return [Object] the object matching the identifier or nil if not found
      def lookup(identifier)
         @stack.reverse_each do |scope|
            value = lookup_identifier(scope, identifier)

            return value unless value.nil?
         end
         
         nil
      end

      # assigns the given value to the given identifier at the highest current
      # scope of the stack.
      #
      # @param [String] identifier the name of the variable to store
      # @param [Object] value the value to assign to the given name
      def assign(identifier, value)
         @stack.last[identifier.to_sym] = value
      end

      # creates a new scope on the variable stack and assigns the given hash
      # to it.
      #
      # @param [Hash] scope the mapping of names to values for the new scope
      # @return nil
      def push(scope)
         # TODO: symbolizing strings is slow so consider symbolizing here to improve
         # the speed of the lookup method (its more important than push)

         # TODO: since you can assign with the #assign method then make the scope
         # variable optional (assigns an empty hash)
         @stack.push(scope)

         nil
      end

      # removes the highest scope from the variable stack
      # @return [Hash] the removed scope
      def pop
         @stack.pop
      end

      # defines a filter proc with the given name
      #
      # @param [Symbol] name the name for the template to use for this filter
      # @yield [String, *args] the block will receive the input string and a 
      #                        variable number of arguments passed to the filter.
      # @return nil
      def define_filter(name, &block)
         @filters[name.to_sym] = block
         nil
      end

      # calls the defined filter proc with the given parameters and returns the
      # result.  
      #
      # @raise [FilterNotDefinedError] if the named filter doesn't exist
      # @param [Symbol] name the name of the filter to evaluate
      # @param [Array] params a list of parameters to pass to the filter 
      #                block when calling it.
      # @return [String] the result of evaluating the filter
      def evaluate_filter(name, params=[])
         filter = @filters[name.to_sym]
         raise FilterNotDefinedError.new("undefined filter '#{name}'") if filter.nil?
         filter.call(*params)
      end

      # defines a functional variable proc with the given name
      #
      # @param [Symbol] name the name for the template to use for this variable
      # @yield [Context, *args] the block will receive the context object and a
      #                         variable number of arguments passed to the variable.
      # @return nil
      def define_functional_variable(name, &block)
         @functional_variables[name.to_sym] = block
         nil
      end

      # calls the defined functional variable proc with the given parameters and
      # returns the result.
      #
      # @raise [FunctionalVariableNotDefinedError] if the named variable doesn't exist
      # @param [Symbol] name the name of the functional variable to evaluate
      # @param [Array] params a list of parameters to pass to the variable
      #                block when calling it
      # @return [Object] the result of  evaluating the functional variable
      def evaluate_functional_variable(name, params=[])
         var = @functional_variables[name.to_sym]
         raise FunctionalVariableNotDefinedError.new("undefined functional variable '#{name}'") if var.nil?
         var.call([self] + params)
      end

      # defines a generic block proc with the given name
      #
      # @param [Symbol] name the name for the template to use for this block
      # @yield [Context, Array, *args] the block will receive the context object,
      #                                a list of Node objects (it's children), and
      #                                a variable number of aarguments passed to
      #                                the block.
      # @return nil
      def define_block(name, &block)
         @blocks[name.to_sym] = block
         nil
      end

      # calls the defined generic block proc with the given name and children
      # nodes.
      #
      # @raise [BlockNotDefinedError] if the named block does not exist
      # @param [Symbol] name the name of the block to evaluate
      # @param [Array] nodes the child nodes of the block
      # @param [Array, []] params a list of parameters to pass to the block
      #                    when calling it.
      # @return [String] the result of evaluating the block
      def evaluate_block(name, nodes, parameters)
         block = @blocks[name.to_sym]
         raise BlockNotDefinedError.new("undefined block '#{name}") if block.nil?
         block.call(self, nodes, parameters)
      end

      # adds the given loader to the end of the loader list.  If the argument 
      # passed is a string then a {FilesystemLoader} will be constructed with
      # the string given as a path for it.
      #
      # @param [Loader,String] loader the loader to add
      # @return nil
      def add_loader(loader)
         if loader.is_a?(String)
            @loaders.push FilesystemLoader.new(loader)
         else
            @loaders.push loader
         end
         nil
      end

      # removes all loaders from the context
      # @return nil
      def clear_loaders
         @loaders.reject! { true }
         nil
      end

      # loads and returns the given template but does not parse it
      #
      # @raise [TemplateNotFoundError] if {#whiny_template_loading} is enabled and
      #                                the template could not be loaded.
      # @param [String] template_name the name of the template to load
      # @return [String] the template text or nil if the template could not be loaded
      def load_source(template_name)
         source = nil

         @loaders.each do |loader|
            source = loader.load_source(template_name)
            break if source
         end

         if source.nil? and whiny_template_loading
            raise TemplateNotFoundError.new(template_name)
         else
            return source
         end
      end

      # loads and returns the given template but does not parse it
      #
      # @raise [TemplateNotFoundError] if the template could not be loaded
      # @param [String] template_name the name of the template to load
      # @return [String] the template text
      def load_source!(template_name)
         load_source(template_name) || raise(TemplateNotFoundError.new(template_name))
      end

      # loads, parses and returns the given template
      #
      # @raise [TemplateNotFoundError] if {#whiny_template_loading} is enabled and
      #                                the template could not be loaded.
      # @param [String] template_name the name of the template to load
      # @return [DocumentNode] the root of the parsed document or nil if the 
      #                          template could not be loaded.
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

      # loads, parses and returns the given template
      #
      # @raise [TemplateNotFoundError] if the template could not be loaded
      # @param [String] template_name the name of the template ot load
      # @return [DocumentNode] the root of the parsed document
      def load_template!(template_name)
         load_template(template_name) || raise(TemplateNotFoundError.new(template_name))
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

         # if a functional variable is defined matching the identifier name then return that
         return @functional_variables[sym_identifier] if @functional_variables.has_key?(sym_identifier)
         
         nil
      end

   end

end