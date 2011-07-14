CADENZA_ROOT = File.expand_path("cadenza", File.dirname(__FILE__)) 

require File.join CADENZA_ROOT, "filters", "standard"
require File.join CADENZA_ROOT, "statements", "standard"
require File.join CADENZA_ROOT, "lexer"
require File.join CADENZA_ROOT, "parser"
require File.join CADENZA_ROOT, "loader"
require File.join CADENZA_ROOT, "node"
require File.join CADENZA_ROOT, "version"

# Rails 3 integration
if defined?(Rails) and Rails.version >= "3.0.0"
  require File.join CADENZA_ROOT, "rails", "railtie"
  require File.join CADENZA_ROOT, "rails", "template_handler"
end