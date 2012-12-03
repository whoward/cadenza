require 'cgi'

# adds slashes to \, ', and " characters in the given string
define_filter :addslashes do |string|
   word = string.dup
   word.gsub!(/\\/, "\\\\\\\\")
   word.gsub!(/'/, "\\\\'")
   word.gsub!(/"/, "\\\"")
   word
end

# capitalizes the first letter of the string
define_filter :capitalize, &:capitalize

# centers the string in a fixed width field with the given padding
define_filter :center do |string, length, *args|
   padding = args.first || ' ' # Ruby 1.8.x compatibility
   string.center(length, padding)
end

# removes all instances of the given string from the string
define_filter :cut do |string, value|
   string.gsub(value, '')
end

# formats the given date object with the given format string
define_filter :date do |date, *args|
   format = args.first || '%F' # Ruby 1.8.x compatibility
   date.strftime(format)
end

# returns the given value if the input is falsy or is empty
define_filter :default do |input, default|
   if input.respond_to?(:empty?) and input.empty?
      default
   else
      input || default
   end
end

# escapes the HTML content of the value
define_filter :escape do |input|
   CGI::escapeHTML(input)
end

# returns the first item of an iterable
define_filter :first do |input|
   if input.respond_to?(:[])
      RUBY_VERSION =~ /^1.8/ && input.is_a?(String) ? input[0].chr : input[0]
   else
      input.first
   end
end

# returns the last item of an iterable
define_filter :last do |input|
   if input.respond_to?(:[])
      RUBY_VERSION =~ /^1.8/ && input.is_a?(String) ? input[-1].chr : input[-1]
   else
      input.last
   end
end

# glues together elements of the input with the glue string
define_filter :join do |input, glue|
   input.join(glue)
end

# returns the length of the input
define_filter :length, &:length

# returns the string left justified with the given padding character
define_filter :ljust do |input, length, *args|
   padding = args.first || ' '  # Ruby 1.8.x compatibility
   input.ljust(length, padding)
end

# returns the string right justified with the given padding character
define_filter :rjust do |input, length, *args|
   padding = args.first || ' '  # Ruby 1.8.x compatibility
   input.rjust(length, padding)
end

# returns the string downcased
define_filter :lower, &:downcase

# returns the string upcased
define_filter :upper, &:upcase

# returns the given words wrapped to fit inside the given column width.  Wrapping
# is done on word boundaries so that no word cutting is done.
# source: http://www.java2s.com/Code/Ruby/String/WordwrappingLinesofText.htm
define_filter :wordwrap do |input, length, *args|
   linefeed = args.first || "\n" # Ruby 1.8.x compatibility
   input.gsub(/(.{1,#{length}})(\s+|\Z)/, "\\1#{linefeed}")
end

# returns the string or array reversed
define_filter :reverse, &:reverse

# returns the string or array with the first +length+ items/characters contained
define_filter :limit do |input, length, *args|
   if length > 0
      input.slice(0..length-1)
   else
      input.is_a?(Array) ? [] : ""
   end
end

# returns the string or array with all items/characters after the +index+ 
# item/character (where 1 is the first index, not 0 as programmers are used to)
define_filter :offset do |input, index, *args|
   input.slice(index..-1)
end