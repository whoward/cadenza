CADENZA_ROOT = File.join(File.dirname(__FILE__), 'lib') 

require "#{CADENZA_ROOT}/filters/standard"
require "#{CADENZA_ROOT}/lexer"
require "#{CADENZA_ROOT}/parser"
require "#{CADENZA_ROOT}/loader"
require "#{CADENZA_ROOT}/node"


lib_exists = Proc.new do | lib |
  begin
    require lib
    return true
  rescue LoadError
    return false
  end
end

# If certain gems are installed then 
if lib_exists.call("rubygems")
  # ActiveSupport provides some nice capitalizing and humanizing string filter support
  require "#{CADENZA_ROOT}/filters/activesupport" if lib_exists.call("activesupport")
  
end

# If rails is defined we want to provide integration for it
if defined?(Rails)
  # We want cadenza as a template handler
  require "#{CADENZA_ROOT}/lib/rails/cadenza_view"
  
  # And register it with actionview as a template handler
  ActionView::Base::register_template_handler :cadenza, CadenzaView
end