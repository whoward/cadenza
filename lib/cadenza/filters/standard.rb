require 'cgi'

module Cadenza
  class Filters
    def self.addslashes(string)
      return string.gsub(/\\/, "\\\\").gsub(/"/,'\\\\"').gsub(/'/,"\\\\'")
    end
    
    def self.capitalize(string)
      return string.capitalize
    end
    
    def self.center(string, len, padstr=' ')
      return string.center(len,padstr)
    end
    
    def self.cut(string, value)
      return string.gsub(value,'')
    end
    
    def self.date(date, format='%F')
      return date.strftime(format)
    end

    def self.default(value, default)
      if value.respond_to?('empty?')
        return (value.empty?) ? default : value
      else
        return value ? value : default
      end
    end
    
    #TODO: dictsort
    #TODO: dictsortreversed
    
    def self.escape(string)
      return CGI::escapeHTML(string)
    end
    
    #TODO: escapejs
    
    #TODO: filesizeformat - use actionview http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
    
    def self.first(value)
      return value.first
    end
    
    #TODO: rename floatformat to round - it makes more sense
    
    #TODO: iriencode
    
    def self.join(value, glue)
      return value.join(glue)
    end
    
    def self.last(value)
      return value.last
    end
    
    def self.length(value)
      return value.length
    end
    
    #TODO: make a standard_html library for stuff that is obviously only for html
    
    #TODO: linenumbers
    
    def self.ljust(string,width)
      return string.ljust(width)
    end
    
    def self.lower(string)
      return string.downcase
    end
    
    #TODO: make_list
    
    #TODO: pluralize (activesupport)
    
    #TODO: random
      
    #TODO: removetags
    
    def self.rjust(string,width)
      return string.rjust(width)
    end
    
    #TODO: slice
    
    #TODO: slugify
    
    #TODO: stringformat
    
    #TODO: striptags
    
    #TODO: time
    
    #TODO: timesince - except return a date object, which can be passed to a timespan_humanize filter or something
    
    #TODO: timeuntil
    
    #TODO: title (activesupport)
    
    #TODO: truncatewords
    
    #TODO: unordered_list
    
    def self.upper(string)
      return string.upcase
    end
    
    #TODO: urlencode
    
    #TODO: urlize
    
    #TODO: wordcount
    
    def self.wordwrap(string, length, separator="<br/>")
      result = ""
      string = string.clone
      while string and string.length > 0
        result << string.slice!(0..length-1) << separator
      end
      return result
    end
    
    #TODO: yesno
    
  end
end