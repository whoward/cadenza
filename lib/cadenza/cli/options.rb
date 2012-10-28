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

      def add_load_path(path)
        @options[:load_paths] ||= []
        @options[:load_paths] << path
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
        on("-I", "--load-path PATH", "Add a path for the filesystem loader") do |path|
          add_load_path(path)
        end

      end

    end

end
