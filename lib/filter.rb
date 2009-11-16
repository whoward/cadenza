class Filters
  def self.upper(string)
    return string.upcase
  end
  
  def self.wordwrap(string, length, separator="<br/>")
    result = ""
    string = string.clone
    while string and string.length > 0
      result << string.slice!(0..length-1) << separator
    end
    return result
  end
end