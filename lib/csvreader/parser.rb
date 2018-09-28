# encoding: utf-8

class CsvReader


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
