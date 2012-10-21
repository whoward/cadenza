require 'optparse'
require 'json'
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
        @options[:context] = JSON.parse(context)
      end

      def set_opts
        on("--context json") do |value|
          context_option value
        end
      end
    end

    def self.run!(path, context)
      Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(File.expand_path('.'))
      Cadenza::BaseContext.whiny_template_loading = true

      Cadenza.render_template path, context
    end

  end
end
