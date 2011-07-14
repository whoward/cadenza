
module Cadenza
  module Rails
    class Railtie < ::Rails::Railtie

      initializer "register_cadenza_template_handler" do
        ActionView::Template.register_template_handler :cadenza, Cadenza::Rails::TemplateHandler.new
      end

    end
  end
end