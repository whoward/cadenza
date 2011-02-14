require 'strscan'
module Cadenza

  class Token < Struct.new(:value, :line, :column)
    def ==(rhs)
      self.value == rhs.value
    end
  end
  
  class Lexer
    
    attr_accessor :line, :column
    
    def position
      [@column, @line]
    end
    
    def source=(src)
      src = '' if src.nil?
      
      @line = 1
      @column = 1 
      @context = :body
      
      @scanner = StringScanner.new(src)
    end
    
    def make_token(type, value, column_count=nil, line_count=0)
      token = [type, Token.new(value, @line, @column)]
      
      @column += value.length if column_count.nil?
      @line += line_count
      
      return token
    end
        
    def scan_text
      case
        when m = @scanner.scan(/\{\{/)
          @context = :statement
          return make_token(:VAR_OPEN, m)
        
        when m = @scanner.scan(/\{%/)
          @context = :statement
          return make_token(:STMT_OPEN, m)
          
        # comments, skip the entire content
        when m = @scanner.scan(/\{#/) 
          m = @scanner.scan_until(/#\}/)
          
          # if no ending for this comment was found then just return the final token
          return [false, false] if m.nil?
          
          comment_text = '{#' + m
          
          line_count = comment_text.count("\n")
          if line_count > 0
            @line += line_count
            @column = comment_text.length - comment_text.rindex("\n")
          else
            @column += comment_text.length
          end

          return scan_text
          
        else
          # scan ahead until we find a variable opening tag or a block opening tag
          m = @scanner.scan_until(/\{[\{%#]/)
          
          # if there was no instance of an opening block then just take what remains 
          # in the scanner otherwise return the pointer to before the block
          if m.nil?
            text_block = @scanner.rest
            @scanner.terminate
          else
            text_block = m[0..-3]
            @scanner.pos = @scanner.pos - 2
          end
          
          # Make the token before advancing the counters
          token = make_token(:TEXT_BLOCK, text_block, 0, 0)
          
          # if there were new lines in the text block then add them to the line count
          # and count the number of characters since the last line break, otherwise
          # add the number of characters in the text block to the column count.
          count = text_block.count("\n")
          if count > 0
            @line += count
            @column = text_block.length - text_block.rindex("\n")
          else
            @column += text_block.length
          end
          
          return token
  
      end
    end
    
    def scan_statement
      scan_whitespace
      
      case
        when m = @scanner.scan(/\}\}/)
          @context = :body
          return make_token(:VAR_CLOSE, m)
          
        when m = @scanner.scan(/%\}/)
          @context = :body
          return make_token(:STMT_CLOSE, m)
          
        when m = @scanner.scan(/==/)
          return make_token(:OP_EQ, m)
        
        when m = @scanner.scan(/!=/)
          return make_token(:OP_NEQ, m)
          
        when m = @scanner.scan(/>=/)
          return make_token(:OP_GEQ, m)
        
        when m = @scanner.scan(/<=/)
          return make_token(:OP_LEQ, m)
          
        when m = @scanner.scan(/=>/)
          return make_token(:OP_MAP, m)
          
        # Keywords, require space afterwards so that identifiers can begin with keywords (but not match them)
        #TODO: this requires space after a keyword, really i just want some non-keyword thing
        when m = @scanner.scan(/(if|else|endif|for|in|endfor|block|endblock|extends|render)\s+/)
          return make_token(m.chop.upcase.to_sym, m.chop, m.length)
  
        when m = @scanner.scan(/[A-Za-z_][A-Za-z0-9_\.]*/)
          return make_token(:IDENTIFIER, m)
          
        when m = @scanner.scan(/['][^']*[']|["][^"]*["]/)
          return make_token(:STRING, m[1..-2], m.length, m.count("\n"))
        
        when m = @scanner.scan(/[0-9]+[\.][0-9]+/)
          return make_token(:REAL, m.to_f, m.length)
          
        when m = @scanner.scan(/[1-9][0-9]*|0/)
          return make_token(:INTEGER, m.to_i, m.length)
          
        # any single character
        when m = @scanner.scan(/./)
          return make_token(m, m)
          
      end
    end
    
    def scan_whitespace
      return unless m = @scanner.scan(/\s+/)
      
      count = m.count("\n")
      if count > 0
        @line += count
        @column = m.length - m.rindex("\n")
      else
        @column += m.length
      end
    end

    
    def next_token
      return [false, false] if @scanner.eos?
      
      case @context
        when :body
          return scan_text
        when :statement
          return scan_statement
        else
          raise "Unknown lexing context: #{@context}"
      end
  
    end
    
    def remaining_tokens
      result = Array.new
      
      while (token = next_token) != [false, false]
        result << token
      end
      
      return result + [[false, false]]
    end
    
  end

end