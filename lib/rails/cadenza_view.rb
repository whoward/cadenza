
class CadenzaView
  @@loader = Cadenza::FilesystemLoader
  
  def initialize(view)
    logger.debug('cadenzaview created: ' << view.inspect)
  end
  
  def render(template, local_assigns = {})
    logger.debug('cadenzaview.render: (template:) %s (local_assigns:) %s' % [template.inspect, local_assigns.inspect])
    
    "template: %s\n\n\nlocal_assigns: %s" % [template.inspect, local_assigns.inspect]
  end
end