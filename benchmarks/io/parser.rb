# encoding: utf-8

class Parser

LF	          = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	          = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)

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
      loop do
        line << input.getc
        c = input.peek
        break if c==LF || c==CR || input.eof?
      end
      recs << line
      skip_newline( input )
    end
  end
  recs
end

def self.skip_newline( input )    ## note: singular (strict) version
  return if input.eof?

  ## only skip CR LF or LF or CR
  if input.peek == CR
    input.getc ## eat-up
    input.getc  if input.peek == LF
  elsif input.peek == LF
    input.getc ## eat-up
  else
    # do nothing
  end
end

end # class Parser
