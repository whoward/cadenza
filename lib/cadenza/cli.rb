require 'optparse'
require 'multi_json'

module Cadenza
  class Cli
    class Options < OptionParser
      attr_reader :options

      def self.parse!
        parser = new("Cadenza")
        parser.set_opts.parse!
        parser.options
      end

      def initialize(*args)
        @options = {}
        super
      end

      def context_option(context)
        @options[:context] = MultiJson.load(context)
      end

      def set_opts
        on("--context json") do |value|
          context_option value
        end
        on("--root path") do |value|
          @options[:root] = value
        end

      end
    end

    def self.run!(path, options={})

      root = options[:root] || File.expand_path(Dir.pwd)
      Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(root)
      Cadenza::BaseContext.whiny_template_loading = true

      Cadenza.render_template path, options[:context]
    end

  end
end
