# encoding: utf-8

class ParserNobuf

LF	          = "\n"     ##   \n == ASCII 0x0A (hex) 10 (dec) = LF (Newline/line feed)
CR	          = "\r"     ##   \r == ASCII 0x0D (hex) 13 (dec) = CR (Carriage return)

def self.parse( input )
  recs = []
  if input.eof?
  else
    c = input.getc
    loop do
      ## non-blanl line
      line = ""

      if c==LF || c==CR || input.eof?
        ## blank line
        recs << line
        break if input.eof?
        c = skip_newline( c, input )
      else
        loop do
          line << c
          c = input.getc
          break if c==LF || c==CR || input.eof?
        end
        recs << line
        break if input.eof?
        c = skip_newline( c, input )
      end
    end
  end
  recs
end


def self.skip_newline( c, input )
  return c if input.eof?

  ## only skip CR LF or LF or CR
  if c == CR
    c = input.getc
    c = input.getc  if c == LF
    c
  elsif c == LF
    c = input.getc ## eat-up
    c
  else
    # do nothing
    c
  end
end

end # class ParserNobuf
