require 'strscan'

module Cadenza

  class Lexer
    def initialize
      @line = 0
      @column = 0
    end

    def source=(source)
      @scanner = ::StringScanner.new(source || "")

      @line = 1
      @column = 1

      @context = :body
    end

    def position
      [@line, @column]
    end

    def next_token
      if @scanner.eos?
        [false, false]
      else
        send("scan_#{@context}")
      end
    end

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
      value = case type
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
      case
        when text = @scanner.scan(/\{\{/) 
          @context = :statement
          token(:VAR_OPEN, text)

        when text = @scanner.scan(/\{%/)
          @context = :statement
          token(:STMT_OPEN, text)

        when text = @scanner.scan(/\{#/)
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
      case
        when text = @scanner.scan(/\}\}/)
          @context = :body
          token(:VAR_CLOSE, text)
        
        when text = @scanner.scan(/%\}/)
          @context = :body
          token(:STMT_CLOSE, text)

        when text = @scanner.scan(/[=]=/) # i've added the square brackets because syntax highlighters dont like /=
          token(:OP_EQ, text)

        when text = @scanner.scan(/!=/)
          token(:OP_NEQ, text)

        when text = @scanner.scan(/>=/)
          token(:OP_GEQ, text)

        when text = @scanner.scan(/<=/)
          token(:OP_LEQ, text)

        when text = @scanner.scan(/(if|else|endif|for|in|endfor|block|endblock|extends|end|and|or|not)[\W]/)
          keyword = text[0..-2]
          @scanner.pos -= 1

          token(keyword.upcase.to_sym, keyword)

        when text = @scanner.scan(/[+\-]?[0-9]+\.[0-9]+/)
          token(:REAL, text)

        when text = @scanner.scan(/[+\-]?[1-9][0-9]*|0/)
          token(:INTEGER, text)
        
        when text = @scanner.scan(/['][^']*[']|["][^"]*["]/)
          token(:STRING, text)

        when text = @scanner.scan(/[A-Za-z_][A-Za-z0-9_\.]*/)
          token(:IDENTIFIER, text)

        else
          next_character = @scanner.getch
          token(next_character, next_character)
      end
    end
  end

end