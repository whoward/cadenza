module Cadenza
  module Cli
    # The parser for the command line options is defined here
    class Options < OptionParser
      attr_reader :options

      def self.parse!
        parser = new('Cadenza')
        parser.set_opts.parse!
        parser.options
      end

      def initialize(*args)
        @options = { action: :render }
        super
      end

      def context_option(context)
        context = File.read(context) if File.exist?(context)
        @options[:context] = MultiJson.load(context)
      end

      def add_load_path(path)
        @options[:load_paths] ||= []
        @options[:load_paths] << path
      end

      def set_opts
        on('--context json') do |value|
          context_option value
        end
        on('-c json') do |value|
          context_option value
        end
        on('--root path') do |value|
          @options[:root] = value
        end
        on('-I', '--load-path PATH', 'Add a path for the filesystem loader') do |path|
          add_load_path(path)
        end
        on('--tokenize', 'only tokenize the input and dump it, do not parse or render') do
          @options[:action] = :tokenize
        end
        on('--parse', 'only parse the input and dump it, do not render') do
          @options[:action] = :parse
        end
        on('--render', 'tokenize, parse and render the input (default)') do
          @options[:action] = :render
        end
      end
    end
  end
end
