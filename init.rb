CADENZA_ROOT = File.join(File.dirname(__FILE__), 'lib') 

require "#{CADENZA_ROOT}/filters/standard"
require "#{CADENZA_ROOT}/statements/standard"
require "#{CADENZA_ROOT}/lexer"
require "#{CADENZA_ROOT}/parser"
require "#{CADENZA_ROOT}/loader"
require "#{CADENZA_ROOT}/node"

def lib_exists(lib)
  begin
    require lib
    return true
  rescue LoadError
    return false
  end    
end

# If certain gems are installed then we want to implement some integration 
if lib_exists("rubygems")
  # ActiveSupport provides some nice capitalizing and humanizing string filter support
  require "#{CADENZA_ROOT}/filters/active_support" if lib_exists("activesupport")
  
  if lib_exists('action_view') and lib_exists('action_controller')
    require "#{CADENZA_ROOT}/statements/action_view/asset_tag_helper"
  end
  
  
end

# If rails is defined we want to provide integration for it
if defined?(Rails)
  # We want cadenza as a template handler
  require "#{CADENZA_ROOT}/rails/cadenza_view"
end