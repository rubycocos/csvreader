
class CsvReader
class Parser

def self.parse( data, sep:  Csv.config.sep,
                      trim: Csv.config.trim? )
  puts "parse:"
  pp data

  parser = new
  parser.parse( data, sep: sep, trim: trim )
end


def self.parse_line( data, sep:  Csv.config.sep,
                           trim: Csv.config.trim? )
  puts "parse_line:"

  parser = new
  records = parser.parse( data, sep: sep, trim: trim, limit: 1 )

  ## unwrap record if empty return nil - why? why not?
  ##  return empty record e.g. [] - why? why not?
  records.size == 0 ? nil : records.first
end



def self.read( path, sep:  Csv.config.sep,
                     trim: Csv.config.trim? )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.parse( file, sep: sep, trim: trim )
  end
end

def self.foreach( path, sep:  Csv.config.sep,
                        trim: Csv.config.trim?, &block )
  parser = new
  File.open( path, 'r:bom|utf-8' ) do |file|
    parser.foreach( file, sep: sep, trim: trim, &block )
  end
end


#### fix!!! remove - replace with parse with (optional) block!!!!!
def self.parse_lines( data, sep:  Csv.config.sep,
                            trim: Csv.config.trim?, &block )
  parser = new
  parser.parse_lines( data, sep: sep, trim: trim, &block )
end




def skip_newlines( io )
  return if io.eof?

  while (c=io.peek; c==LF || c==CR)
    io.getc    ## eat-up all \n and \r
  end
end


end # class Parser
end # class CsvReader
