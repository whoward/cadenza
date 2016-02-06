require 'optparse'
require 'cadenza/cli/options'
require 'multi_json'

module Cadenza
  # The code for the command line interface is defined here
  module Cli
    module_function

    def run!(path, options = {})
      # set up the load paths
      if options[:root]
        load_paths.push(options[:root])
      elsif options.fetch(:load_paths, []).any?
        load_paths.concat(options[:load_paths])
      else
        load_paths.push(Dir.pwd)
      end

      # add load paths to the context
      load_paths.each do |load_path|
        context.add_load_path load_path
      end

      # based on the action, perform whatever the user has asked
      send(options[:action], path, options)
    end

    def tokenize(path, _options)
      lexer = Cadenza::Lexer.new
      lexer.source = context.load_source!(path)
      $stdout.puts lexer.remaining_tokens.map(&:inspect).join("\n")
    end

    def parse(path, _options)
      $stdout.puts context.load_template!(path).to_tree
    end

    def render(path, options)
      Cadenza.render_template path, options[:context], context: context
    end

    private

    def load_paths
      @load_paths ||= []
    end

    def context
      @context ||= begin
        context = Cadenza::BaseContext.new
        context.whiny_template_loading = true
        context
      end
    end
  end
end
