module Cadenza::Cli

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
        if File.exist?(context)
          context = File.read(context)
        end
        @options[:context] = MultiJson.load(context)
      end

      def set_opts
        on("--context json") do |value|
          context_option value
        end
        on("-c json") do |value|
          context_option value
        end
        on("--root path") do |value|
          @options[:root] = value
        end

      end

    end

end
