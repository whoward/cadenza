class CadenzaTemplateHandler < ActionView::TemplateHandler
  def render(template, local_assigns = {})
    Cadenza::FilesystemLoader.template_paths.clear
    Cadenza::FilesystemLoader.template_paths.push(File.join(RAILS_ROOT, template.load_path))
    
    context = Hash.new
    @view.instance_variables.each do | instance_variable |
      name = instance_variable[1..-1]  # slice the @ out of the instance variable
      value = @view.instance_variable_get(instance_variable)
      context.store(name, value)
    end
    
    begin
      return Cadenza::Loader.get_template('Filesystem', template.template_path).render(context,'')
    rescue StandardError
      return "an error occured with the template! #{template.template_path} #{$!}"
    end
  end
  
end