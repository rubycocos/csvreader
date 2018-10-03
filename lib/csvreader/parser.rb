# encoding: utf-8

class CsvReader

class Parser

## use/allow different "backends" e.g. ParserStd, ParserStrict, ParserTab, etc.
##   parser must support parse method (with and without block)
##    e.g.  records = parse( data )
##             -or-
##          parse( data ) do |record|
##          end


DEFAULT = ParserStd.new

RFC4180 = ParserStrict.new
STRICT  = ParserStrict.new  ## note: make strict its own instance (so you can change config without "breaking" rfc4180)
EXCEL   = ParserStrict.new   ## note: make excel its own instance (so you can change configs without "breaking" rfc4180/strict)

MYSQL   = ParserStrict.new( sep: "\t",
                            quote: false,
                            escape: true,
                            null: "\\N" )

POSTGRES = POSTGRESQL = ParserStrict.new( doublequote: false,
                                          escape: true,
                                          null: "" )

POSTGRES_TEXT = POSTGRESQL_TEXT = ParserStrict.new( sep: "\t",
                                                    quote: false,
                                                    escape: true,
                                                    null: "\\N" )

TAB     = ParserTab.new


def self.default()         DEFAULT;         end ## alternative alias for DEFAULT
def self.strict()          STRICT;          end ## alternative alias for STRICT
def self.rfc4180()         RFC4180;         end ## alternative alias for RFC4180
def self.excel()           EXCEL;           end ## alternative alias for EXCEL
def self.mysql()           MYSQL;           end
def self.postgresql()      POSTGRESQL;      end
def self.postgres()        postgresql;      end
def self.postgresql_text() POSTGRESQL_TEXT; end
def self.postgres_text()   postgresql_text; end
def self.tab()             TAB;             end

end # class Parser



####################################
# define errors / exceptions
#   for all parsers for (re)use

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
    "*** csv parse error: #{@message}"
  end
end # class ParseError
end # class CsvReader
