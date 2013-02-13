require 'optparse'
require 'cadenza/cli/options'
require 'multi_json'

module Cadenza
  module Cli

    def self.run!(path, options={})

      load_paths =
        if options[:root]
          [options[:root]]
        elsif options.key?(:load_paths) && [:load_paths].any?
          options[:load_paths]
        else
          [Dir.pwd]
        end

      context = Cadenza::BaseContext.new

      load_paths.each do |load_path|
        context.add_load_path load_path
      end

      context.whiny_template_loading = true

      Cadenza.render_template path, options[:context], {:context => context}

    end

  end
end
