# encoding: utf-8

class CsvReader

##

class Error < StandardError
end

####
# todo/check:
#  use "common" error class - why? why not?

class ParseError < Error
  attr_reader :message

   def initialize( message )
     @message = message
   end

   def to_s
     "** csv parse error: #{@message}"
   end
 end



class Parser

## use/allow different "backends"
DEFAULT = ParserStd.new

RFC4180 = ParserStrict.new
EXCEL   = ParserStrict.new


def self.default()  DEFAULT; end    ## alternative alias for DEFAULT
def self.rfc4180()  RFC4180; end    ## alternative alias for RFC4180
def self.excel()    EXCEL; end      ## alternative alias for EXCEL


end # class Parser
end # class CsvReader
