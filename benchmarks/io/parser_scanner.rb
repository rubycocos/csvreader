# encoding: utf-8

class ParserScanner


NOT_COMMA_OR_NEWLINE_RX = /[^,\n\r]*/

NEWLINE_RX =  /\r?\n/


LF	  = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	  = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)
COMMA = ","

def self.parse_record( input )
  values = []

  loop do
    value = input.scan( NOT_COMMA_OR_NEWLINE_RX )
    values << value

    if input.eof?
      break
    elsif (c=input.peek; c==LF || c==CR)
      skip_newline( input )
      break
    elsif input.peek == COMMA
      input.getc  ## eat-up comma
    else
      puts "!! error - found >#{input.peek} (#{input.peek.ord})< - FS (,) or RS (\\n) expected!!!!"
      exit(1)
    end
  end

  values
end


def self.parse( input )
  recs = []
  loop do
    break if input.eof?

    ## non-blanl line
    line = ""

    c = input.peek
    if c==LF || c==CR || input.eof?
      ## blank line
      recs << line
      skip_newline( input )
    else
      ## line << input.scan_until_newline
      ## recs << line
      ## skip_newline( input )

      line = parse_record( input )
      recs << line
    end
  end
  recs
end

def self.skip_newline( input )    ## note: singular (strict) version
  return if input.eof?

  input.skip( NEWLINE_RX )
end

end # class Parser
