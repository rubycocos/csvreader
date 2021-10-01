# encoding: utf-8


def readline( input )
  recs = []
  input.each_line do |line|
     line = line.chomp
     recs << line.split( "," )
  end
  recs
end

def readline_inplace( input )
  recs = []
  input.each_line do |line|
     line.chomp!   ## use "inplace" chomp version
     recs << line.split( "," )
  end
  recs
end




NOT_COMMA_RX = /  [^,]*  /x  ## everything until the next comma (or end of line)

def readline_scanner( input )
  recs = []
  buf  = StringScanner.new( "" )
  input.each_line do |line|
     buf.string = line.chomp    ## was: StringScanner.new( line.chomp )
     rec = []
     loop do
       value = buf.scan( NOT_COMMA_RX )
       rec << value   ## todo: check for value nil/no match - no more value found - why? why not?
       break if buf.eos?
       buf.getch  ## eat-up comma
     end
     recs << rec  # add record
  end
  recs
end



def readchar( input )
  recs = []
  input.each_line do |line|
     line = line.chomp
     rec =  []
     value = ""
     line.each_char do |c|
       if c == ","
         rec << value
         value = ""
       else
         value << c
       end
     end
     rec << value # add last value
     recs << rec  # add record
  end
  recs
end
