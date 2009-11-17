CADENZA_ROOT = File.join(File.dirname(__FILE__), 'lib') 

require "#{CADENZA_ROOT}/filters/standard"
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

if lib_exists("rubygems")
  # ActiveSupport provides some nice capitalizing and humanizing string filter support
  require "#{CADENZA_ROOT}/filters/activesupport" if lib_exists("activesupport")
  
end