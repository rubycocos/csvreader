# encoding: utf-8


require 'pp'
require 'logger'
require 'forwardable'
require 'stringio'
require 'date'    ## use for Date.parse and DateTime.parse
require 'yaml'    ## used for (optional) meta data blocks


require 'tabreader'
require 'csvjson'
require 'csvyaml'


###
# our own code
require 'csvreader/version' # let version always go first
require 'csvreader/buffer'
require 'csvreader/parser_std'      # best practices pre-configured out-of-the-box
require 'csvreader/parser_strict'   # flexible (strict - no leading/trailing space triming, blanks, etc.), configure for different formats/dialects
require 'csvreader/parser_tab'
require 'csvreader/parser_fixed'
require 'csvreader/parser_json'
require 'csvreader/parser_yaml'
require 'csvreader/parser_table'
require 'csvreader/parser'
require 'csvreader/converter'
require 'csvreader/reader'
require 'csvreader/reader_hash'
require 'csvreader/builder'



class CsvReader
class Parser

  ## use/allow different "backends" e.g. ParserStd, ParserStrict, ParserTab, etc.
  ##   parser must support parse method (with and without block)
  ##    e.g.  records = parse( data )
  ##             -or-
  ##          parse( data ) do |record|
  ##          end

  DEFAULT = ParserStd.new
  NUMERIC = ParserStd.new( numeric: true,
                           nan: ['#NAN', 'NAN', 'NaN', 'nan' ],
                           null: "" )
  HUMAN   = ParserStd.new( hashtag: true )


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


  TAB     = ParserTab.new      ## (strict) tab-separated
  TABLE   = ParserTable.new    ## space-separated e.g /[ \t]+/
  FIXED   = ParserFixed.new

  JSON    = ParserJson.new
  YAML    = ParserYaml.new

  def self.default()         DEFAULT;         end ## alternative alias for DEFAULT
  def self.numeric()         NUMERIC;         end
  def self.num()             numeric;         end
  def self.n()               numeric;         end
  def self.human()           HUMAN;           end
  def self.hum()             human;           end
  def self.hxl()             human;           end  ## HXL (humanitarian eXchange language)

  def self.strict()          STRICT;          end ## alternative alias for STRICT
  def self.rfc4180()         RFC4180;         end ## alternative alias for RFC4180
  def self.excel()           EXCEL;           end ## alternative alias for EXCEL
  def self.mysql()           MYSQL;           end
  def self.postgresql()      POSTGRESQL;      end
  def self.postgres()        postgresql;      end
  def self.postgresql_text() POSTGRESQL_TEXT; end
  def self.postgres_text()   postgresql_text; end

  def self.tab()             TAB;             end
  def self.table()           TABLE;           end
  def self.fixed()           FIXED;           end
  def self.fix()             fixed;           end
  def self.f()               fixed;           end

  def self.json()            JSON;            end
  def self.j()               json;            end
  def self.yaml()            YAML;            end
  def self.y()               yaml;            end
end # class Parser
end # class CsvReader



class CsvReader
  ### pre-define CsvReader (built-in) formats/dialect
  DEFAULT = Builder.new( Parser::DEFAULT )
  NUMERIC = Builder.new( Parser::NUMERIC )
  HUMAN   = Builder.new( Parser::HUMAN )

  STRICT  = Builder.new( Parser::STRICT )
  RFC4180 = Builder.new( Parser::RFC4180 )
  EXCEL   = Builder.new( Parser::EXCEL )

  MYSQL                           = Builder.new( Parser::MYSQL )
  POSTGRES = POSTGRESQL           = Builder.new( Parser::POSTGRESQL )
  POSTGRES_TEXT = POSTGRESQL_TEXT = Builder.new( Parser::POSTGRESQL_TEXT )


  TAB   = Builder.new( Parser::TAB )
  TABLE = Builder.new( Parser::TABLE )
  FIXED = Builder.new( Parser::FIXED )

  JSON  = Builder.new( Parser::JSON )
  YAML  = Builder.new( Parser::YAML )

  def self.default()         DEFAULT;         end ## alternative alias for DEFAULT
  def self.numeric()         NUMERIC;         end
  def self.num()             numeric;         end
  def self.n()               numeric;         end
  def self.human()           HUMAN;           end
  def self.hum()             human;           end
  def self.hxl()             human;           end  ## HXL (humanitarian eXchange language)

  def self.strict()          STRICT;          end ## alternative alias for STRICT
  def self.rfc4180()         RFC4180;         end ## alternative alias for RFC4180
  def self.excel()           EXCEL;           end ## alternative alias for EXCEL
  def self.mysql()           MYSQL;           end
  def self.postgresql()      POSTGRESQL;      end
  def self.postgres()        postgresql;      end
  def self.postgresql_text() POSTGRESQL_TEXT; end
  def self.postgres_text()   postgresql_text; end

  def self.tab()             TAB;             end
  def self.table()           TABLE;           end
  def self.fixed()           FIXED;           end
  def self.fix()             fixed;           end
  def self.f()               fixed;           end

  def self.json()            JSON;            end
  def self.j()               json;            end
  def self.yaml()            YAML;            end
  def self.y()               yaml;            end
end # class CsvReader



class CsvHashReader
  ### pre-define CsvReader (built-in) formats/dialect
  DEFAULT = Builder.new( Parser::DEFAULT )
  NUMERIC = Builder.new( Parser::NUMERIC )

  STRICT  = Builder.new( Parser::STRICT )
  RFC4180 = Builder.new( Parser::RFC4180 )
  EXCEL   = Builder.new( Parser::EXCEL )

  MYSQL                           = Builder.new( Parser::MYSQL )
  POSTGRES = POSTGRESQL           = Builder.new( Parser::POSTGRESQL )
  POSTGRES_TEXT = POSTGRESQL_TEXT = Builder.new( Parser::POSTGRESQL_TEXT )


  TAB   = Builder.new( Parser::TAB )
  TABLE = Builder.new( Parser::TABLE )
  FIXED = Builder.new( Parser::FIXED )

  JSON  = Builder.new( Parser::JSON )
  YAML  = Builder.new( Parser::YAML )


  def self.default()         DEFAULT;         end ## alternative alias for DEFAULT
  def self.numeric()         NUMERIC;         end
  def self.num()             numeric;         end
  def self.n()               numeric;         end
  def self.strict()          STRICT;          end ## alternative alias for STRICT
  def self.rfc4180()         RFC4180;         end ## alternative alias for RFC4180
  def self.excel()           EXCEL;           end ## alternative alias for EXCEL
  def self.mysql()           MYSQL;           end
  def self.postgresql()      POSTGRESQL;      end
  def self.postgres()        postgresql;      end
  def self.postgresql_text() POSTGRESQL_TEXT; end
  def self.postgres_text()   postgresql_text; end

  def self.tab()             TAB;             end
  def self.table()           TABLE;           end
  def self.fixed()           FIXED;           end
  def self.fix()             fixed;           end
  def self.f()               fixed;           end

  def self.json()            JSON;            end
  def self.j()               json;            end
  def self.yaml()            YAML;            end
  def self.y()               yaml;            end
end # class CsvHashReader




# say hello
puts CsvReader.banner    if $DEBUG || (defined?($RUBYCOCO_DEBUG) && $RUBYCOCO_DEBUG)
