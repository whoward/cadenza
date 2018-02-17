# frozen_string_literal: true

require 'strscan'

module Cadenza
  # The {Lexer} class accepts in input {IO} object which it will parse simple
  # {Token}s from for use in a {Parser} class.
  class Lexer
    KEYWORDS = %w[if unless else endif endunless for in endfor block endblock extends end and or not].freeze

    # constructs a new parser and sets it to the position (0, 0)
    def initialize
      @line = 0
      @column = 0
    end

    # assigns a new string to retrieve tokens and resets the line and column
    # counters to (1, 1)
    # @param [String] source the string from which to parse tokens
    def source=(source)
      @scanner = ::StringScanner.new(source || '')

      @line = 1
      @column = 1

      @context = :body
    end

    # gives the current line and column counter as a two element array
    # @return [Array] the line and column
    def position
      [@line, @column]
    end

    # Gets the next token and returns it.  Tokens are two element arrays where
    # the first element is one of the following symbols and the second is an
    # instance of {Cadenza::Token} containing the value of the token.
    #
    # valid tokens:
    # - :VAR_OPEN - for opening an inject tag ex. "{{"
    # - :VAR_CLOSE - for closing an inject tag ex. "}}"
    # - :STMT_OPEN - for opening a control tag ex. "{%"
    # - :STMT_CLOSE - for closing a control tag ex. "%}"
    # - :TEXT_BLOCK - for a block of raw text
    # - :OP_EQ - for an equivalence symbol ex. "=="
    # - :OP_NEQ - for a nonequivalence symbol ex. "!="
    # - :OP_GEQ - for a greater than or equal to symbol ex. ">="
    # - :OP_LEQ - for a less than or equal to symbol ex. "<="
    # - :REAL - for a number with a decimal value ex. "123.45"
    # - :INTEGER - for a number without a decimal value ex. "12345"
    # - :STRING - for a string literal, either from single quotes or double quotes ex. "'foo'"
    # - :IDENTIFIER - for a variable name ex. "foo"
    # - :IF - for the 'if' keyword
    # - :UNLESS - for the 'unless' keyword
    # - :ELSE - for the 'else' keyword
    # - :ENDIF - for the 'endif' keyword
    # - :ENDUNLESS - for the 'endunless' keyword
    # - :FOR - for the 'for' keyword
    # - :IN - for the 'in' keyword
    # - :ENDFOR - for the 'endfor' keyword
    # - :BLOCK - for the 'block' keyword
    # - :ENDBLOCK - for the 'endblock' keyword
    # - :EXTENDS - for the 'extends' keyword
    # - :END - for the 'end' keyword
    # - :AND - for the 'and' keyword
    # - :OR - for the 'or' keyword
    # - :NOT - for the 'not' keyword
    #
    # if no tokens are left the return value will be [false, false]
    def next_token
      if @scanner.eos?
        [false, false]
      else
        send("scan_#{@context}")
      end
    end

    # returns an array of all remaining tokens left to be parsed.  See {#next_token}
    # for details regarding the definition of a token.  The array will always end in
    # [false, false].
    #
    # @return [Array] a list of all remaining tokens
    def remaining_tokens
      result = []

      loop do
        result.push next_token
        break if result.last == [false, false]
      end

      result
    end

    private

    #
    # Updates the line and column counters based on the given text.
    #
    def update_counter(text)
      number_of_newlines = text.count("\n")

      if number_of_newlines > 0
        @line += text.count("\n")
        @column = text.length - text.rindex("\n")
      else
        @column += text.length
      end
    end

    #
    # Creates and returns a token with the line and column number from the end of
    # the previous token.  Afterwards updates the counter based on the contents
    # of the text.  The value of the token is determined by the text given and
    # the type of the token.
    #
    def token(type, text)
      value =
        case type
        when :INTEGER then text.to_i
        when :REAL then text.to_f
        when :STRING then text[1..-2]
        else text
        end

      token = Token.new(value, text, @line, @column)

      update_counter(token.source)

      [type, token]
    end

    #
    # Scans the next characters based on the body context (the context the lexer
    # should initially be in), which will attempt to match the opening tokens
    # for statements.  Failing that it will parse a text block token.
    #
    def scan_body
      if (text = @scanner.scan(/\{\{/))
        @context = :statement
        token(:VAR_OPEN, text)

      elsif (text = @scanner.scan(/\{%/))
        @context = :statement
        token(:STMT_OPEN, text)

      elsif (text = @scanner.scan(/\{#/))
        # scan until the end of the comment bracket, ignore the text for all
        # purposes except for advancing the counters appropriately
        comment = @scanner.scan_until(/#\}/)

        # increment the counters based on the content of the counter
        update_counter(text + comment)

        # scan in the body context again, since we're not actually returning a
        # token from the comment.  Don't scan if we're at the end of the body,
        # just return a terminator token.
        if @scanner.eos?
          [false, false]
        else
          scan_body
        end

      else
        # scan ahead until we find a variable opening tag or a block opening tag
        text = @scanner.scan_until(/\{[\{%#]/)

        # if there was no instance of an opening block then just take what remains
        # in the scanner otherwise return the pointer to before the block
        if text
          text = text[0..-3]
          @scanner.pos -= 2
        else
          text = @scanner.rest
          @scanner.terminate
        end

        token(:TEXT_BLOCK, text)
      end
    end

    #
    # Scans the next characters based on the statement context, which will ignore
    # whitespace and look for tokens you would expect to find inside any kind
    # of statement.
    #
    def scan_statement
      # eat any whitespace at the start of the string
      whitespace = @scanner.scan_until(/\S/)

      if whitespace
        @scanner.pos -= 1
        update_counter(whitespace[0..-2])
      end

      # look for matches
      if (text = @scanner.scan(/\}\}/))
        @context = :body
        token(:VAR_CLOSE, text)

      elsif (text = @scanner.scan(/%\}/))
        @context = :body
        token(:STMT_CLOSE, text)

      elsif (text = @scanner.scan(/[=]=/)) # i've added the square brackets because syntax highlighters dont like /=
        token(:OP_EQ, text)

      elsif (text = @scanner.scan(/!=/))
        token(:OP_NEQ, text)

      elsif (text = @scanner.scan(/>=/))
        token(:OP_GEQ, text)

      elsif (text = @scanner.scan(/<=/))
        token(:OP_LEQ, text)

      elsif (text = @scanner.scan(/(#{KEYWORDS.join('|')})[\W]/))
        keyword = text[0..-2]
        @scanner.pos -= 1

        token(keyword.upcase.to_sym, keyword)

      elsif (text = @scanner.scan(/(end[a-zA-Z]+)/))
        token(:END, text.upcase)

      elsif (text = @scanner.scan(/[+\-]?[0-9]+\.[0-9]+/))
        token(:REAL, text)

      elsif (text = @scanner.scan(/[+\-]?[1-9][0-9]*|0/))
        token(:INTEGER, text)

      elsif (text = @scanner.scan(/'[^']*'/))
        token(:STRING, text)

      elsif (text = @scanner.scan(/"(?:[^\\"]|\\.)*"/))
        text.gsub!(/\\"/) { '"' }
        text.gsub!(/\\r/)               { "\r" }
        text.gsub!(/\\n/)               { "\n" }
        text.gsub!(/\\t/)               { "\t" }
        text.gsub!(/\\\\/)              { '\\' }
        text.gsub!(/\\u([0-9a-fA-F]+)/) { |m| [m[2..-1].hex].pack('U') }
        token(:STRING, text)

      elsif (text = @scanner.scan(/[A-Za-z_][A-Za-z0-9_\.]*/))
        token(:IDENTIFIER, text)

      else
        next_character = @scanner.getch
        token(next_character, next_character)
      end
    end
  end
end
