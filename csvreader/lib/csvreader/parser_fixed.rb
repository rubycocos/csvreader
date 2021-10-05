
class CsvReader

class ParserFixed

###################################
## add simple logger with debug flag/switch
#
#  use Parser.debug = true   # to turn on
#
#  todo/fix: use logutils instead of std logger - why? why not?

def self.build_logger()
  l = Logger.new( STDOUT )
  l.level = :info    ## set to :info on start; note: is 0 (debug) by default
  l
end
def self.logger() @@logger ||= build_logger; end
def logger()  self.class.logger; end


def parse( data, width:, &block )

  ## note: input: required each_line (string or io/file for example)

  input = data   ## assume it's a string or io/file handle

  if block_given?
    parse_lines( input, width: width, &block )
  else
    records = []

    parse_lines( input, width: width ) do |record|
      records << record
    end

    records
  end
end ## method parse



private

def parse_lines( input, width:, &block )

  ## note: each line only works with \n (windows) or \r\n (unix)
  ##   will NOT work with \r (old mac, any others?) only!!!!
  input.each_line do |line|

    ##  note: chomp('') if is an empty string,
    ##    it will remove all trailing newlines from the string.
    ##    use line.sub(/[\n\r]*$/, '') or similar instead - why? why not?
    line = line.chomp( '' )
    logger.debug "line:"                if logger.debug?
    logger.debug line.pretty_inspect    if logger.debug?


    ## skip empty lines and comments
    if line =~ /^[ \t]*$/   ## skip blank lines (with whitespace only)
       logger.debug "skip blank line"    if logger.debug?
       next
    end

    if line =~ /^[ \t]*#/   # start_with?( "#" ) -- skip comment lines (note: allow leading whitespaces)
       logger.debug "skip comment line"   if logger.debug?
       next
    end


    if width.is_a?( String )
      ## assume it's String#unpack format e.g.
      ##   "209231-231992395    MoreData".unpack('aa5A1A9a4Z*')
      ##     returns an array as follows :
      ##   ["2", "09231", "-", "231992395", "    ", "MoreData"]
      ##  see String#unpack

      values = line.unpack( width )
    else  ## assume array with integers
      values = []
      offset = 0  # start position / offset
      width.each_with_index do |w,i|
         logger.debug "[#{i}] start: #{offset}, width: #{w}"   if logger.debug?

         if w < 0   ## convention - if width negative, skip column
            # note: minus (-) and minus (-) equal plus (+)
            ##   e.g. 2 - -2 = 4
           offset -= w
         else
           value = line[offset, w]
           value = value.strip   if value    ## note: if not nil strip; only use rstrip (for trailing only) - why? why not?
           values << value
           offset += w
         end
      end
    end

    ## note: requires block - enforce? how? why? why not?
    block.call( values )
  end
end # method parse_lines


end # class ParserFixed
end # class CsvReader
