require 'strscan'

class Cadenza::Lexer
  
  attr_accessor :line, :column
  
  def source=(src)
    src = '' if src.nil?
    
    @line = 1
    @column = 1 
    @context = :body
    
    @scanner = StringScanner.new(src)
    #TODO: the line/column counting is all wrong, mostly with the lines themselves
    #TODO: place line and column data in the token itself
    #TODO: advance column counter after the token is made
  end
  
  def scan_text
    case
      when m = @scanner.scan(/\{\{/)
        @context = :inject_statement
        @column += 2
        return [:VAR_OPEN, m]
      
      when m = @scanner.scan(/\{%/)
        @context = :general_statement
        @column += 2
        return [:STMT_OPEN, m]
        
      else
        m = @scanner.scan_until(/\{[\{%]/)
        
        if m.nil?
          text_block = @scanner.rest
          @scanner.pos = @scanner.string.length
        else
          text_block = m[0..-3]
          @scanner.pos = @scanner.pos - 2
        end
        
        # if there were new lines in the text block then add them to the line count
        # and count the number of characters since the last line break, otherwise
        # add the number of characters in the text block to the column count.
        count = text_block.count("\n")
        if count > 0
          @line += count
          @column = text_block.rindex("\n") - 1
        else
          @column += text_block.length
        end
        
        return [:TEXT_BLOCK, text_block]

    end
  end
  
  def scan_statement_common
    case
      # Keywords, require space afterwards so that identifiers can begin with keywords (but not match them)
      #TODO: this requires space after a keyword, really i just want some non-keyword thing
      when m = @scanner.scan(/(if|else|endif|for|in|endfor|block|endblock|extends)\s+/)
        @column += m.length
        return [m.chop.upcase.to_sym, m.chop]

      when m = @scanner.scan(/[A-Za-z_][A-Za-z0-9_\.]*/)
        @column += m.length
        return [:IDENTIFIER, m]
      
      when m = @scanner.scan(/['][^']*[']|["][^"]*["]/)
        @column += m.length
        return [:STRING, m[1..-2]]
      
      when m = @scanner.scan(/[0-9]+[\.][0-9]+/)
        @column += m.length
        return [:REAL, m.to_f]
        
      when m = @scanner.scan(/[1-9][0-9]*|0/)
        @column += m.length
        return [:INTEGER, m.to_i]
        
      # any single character
      when m = @scanner.scan(/./)
        @column += 1
        return [m, m]
        
    end
  end
  
  def scan_inject_statement        
    # skip to the next non-whitespace character, counting newlines as we go
    match = @scanner.scan(/\s+/)
    @line += match.count("\n") if match
        
    case          
      when m = @scanner.scan(/\}\}/)
        @context = :body
        @column += 2
        return [:VAR_CLOSE, m]
    end
    
    return scan_statement_common
  end
  
  def scan_general_statement
    # skip to the next non-whitespace character, counting newlines as we go
    match = @scanner.scan(/\s+/)
    @line += match.count("\n") if match
    
    case        
      when m = @scanner.scan(/%\}/)
        @context = :body
        @column += 2
        return [:STMT_CLOSE, m]
      
      when m = @scanner.scan(/==/)
        @column += 2
        return [:OP_EQ, m]
      
      when m = @scanner.scan(/!=/)
        @column += 2
        return [:OP_NEQ, m]
        
      when m = @scanner.scan(/>=/)
        @column += 2
        return [:OP_GEQ, m]
      
      when m = @scanner.scan(/<=/)
        @column += 2
        return [:OP_LEQ, m]
    end
    
    return scan_statement_common
  end
  
  def next_token
    return [false, false] if @scanner.empty?
    
    case @context
      when :body
        return scan_text
      when :inject_statement
        return scan_inject_statement
      when :general_statement
        return scan_general_statement
      else
        raise "Unknown token"
    end

  end
  
end