require 'cadenza/cli/options'
require 'optparse'
require 'multi_json'

module Cadenza
  module Cli

    def self.run!(path, options={})

      root = options[:root] || File.expand_path(Dir.pwd)
      Cadenza::BaseContext.add_loader Cadenza::FilesystemLoader.new(root)
      Cadenza::BaseContext.whiny_template_loading = true

      Cadenza.render_template path, options[:context]

    end

  end
end
