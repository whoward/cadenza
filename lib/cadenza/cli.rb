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

      load_paths.each do |load_path|
        Cadenza::BaseContext.add_load_path load_path
      end

      Cadenza::BaseContext.whiny_template_loading = true

      Cadenza.render_template path, options[:context]

    end

  end
end
