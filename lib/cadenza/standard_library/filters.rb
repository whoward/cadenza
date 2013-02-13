require 'cgi'

module Cadenza; end
module Cadenza::StandardLibrary; end

Cadenza::StandardLibrary::Filters = Cadenza::Library.build do

   # adds slashes to \, ', and " characters in the given string
   define_filter :addslashes do |string, params|
      word = string.dup
      word.gsub!(/\\/, "\\\\\\\\")
      word.gsub!(/'/, "\\\\'")
      word.gsub!(/"/, "\\\"")
      word
   end

   # capitalizes the first letter of the string
   define_filter :capitalize do |input, params|
      input.capitalize
   end

   # centers the string in a fixed width field with the given padding
   define_filter :center do |string, params|
      length = params[0]
      padding = params[1] || ' '
      string.center(length, padding)
   end

   # removes all instances of the given string from the string
   define_filter :cut do |string, params|
      string.gsub(params.first, '')
   end

   # formats the given date object with the given format string
   define_filter :date do |date, params|
      format = params.first || '%F'
      date.strftime(format)
   end

   # returns the given value if the input is falsy or is empty
   define_filter :default do |input, params|
      default = params.first

      if input.respond_to?(:empty?) and input.empty?
         default
      else
         input || default
      end
   end

   # escapes the HTML content of the value
   define_filter :escape do |input, params|
      CGI::escapeHTML(input)
   end

   # returns the first item of an iterable
   define_filter :first do |input, params|
      if input.respond_to?(:[])
         RUBY_VERSION =~ /^1.8/ && input.is_a?(String) ? input[0].chr : input[0]
      else
         input.first
      end
   end

   # returns the last item of an iterable
   define_filter :last do |input, params|
      if input.respond_to?(:[])
         RUBY_VERSION =~ /^1.8/ && input.is_a?(String) ? input[-1].chr : input[-1]
      else
         input.last
      end
   end

   # glues together elements of the input with the glue string
   define_filter :join do |input, params|
      glue = params.first
      input.join(glue)
   end

   # returns the length of the input
   define_filter :length do |input, params|
      input.length
   end

   # returns the string left justified with the given padding character
   define_filter :ljust do |input, params|
      length = params[0]
      padding = params[1] || ' '
      input.ljust(length, padding)
   end

   # returns the string right justified with the given padding character
   define_filter :rjust do |input, params|
      length = params[0]
      padding = params[1] || ' '
      input.rjust(length, padding)
   end

   # returns the string downcased
   define_filter :lower do |input, params|
      input.downcase
   end

   # returns the string upcased
   define_filter :upper do |input, params|
      input.upcase
   end

   # returns the given words wrapped to fit inside the given column width.  Wrapping
   # is done on word boundaries so that no word cutting is done.
   # source: http://www.java2s.com/Code/Ruby/String/WordwrappingLinesofText.htm
   define_filter :wordwrap do |input, params|
      length = params[0]
      linefeed = params[1] || "\n"
      input.gsub(/(.{1,#{length}})(\s+|\Z)/, "\\1\n").strip.gsub(/\n/, linefeed)
   end

   # returns the string or array reversed
   define_filter :reverse do |input, params|
      input.reverse
   end

   # returns the string or array with the first +length+ items/characters contained
   define_filter :limit do |input, params|
      length = params.first

      if length > 0
         input.slice(0..length-1)
      else
         input.is_a?(Array) ? [] : ""
      end
   end

   # returns the string or array with all items/characters after the +index+ 
   # item/character (where 1 is the first index, not 0 as programmers are used to)
   define_filter :offset do |input, params|
      index = params.first

      input.slice(index..-1)
   end

   # returns an array of objects with the given identifier looked up on all of the
   # input array elements.
   define_filter :pluck do |input, params|
      identifier = params.first

      input.map {|item| Cadenza::Context.lookup_on_object(identifier, item) }
   end

   alias_filter :pluck, :map
   alias_filter :pluck, :collect

   define_filter :sort do |input, params|
      identifier = params.first

      if identifier
         input.sort {|a,b| Cadenza::Context.lookup_on_object(identifier, a) <=> Cadenza::Context.lookup_on_object(identifier, b) }
      else
         input.sort
      end
   end

end