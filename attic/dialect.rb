class Dialect   ## todo: use a module - it's just a namespace/module now - why? why not?
  ###
  # (auto-)add these flavors/dialects:
  #     :tab                   -> uses TabReader(!)
  #     :strict|:rfc4180
  #     :unix                   -> uses unix-style escapes e.g. \n \" etc.
  #     :windows|:excel
  #     :guess|:auto     -> guess (auto-detect) separator - why? why not?
  #     :mysql    -> add mysql flavor (see apache commons csv - why? why not?)

  # from apache commons csv
  #   see https://commons.apache.org/proper/commons-csv/apidocs/org/apache/commons/csv/CSVFormat.html
  #
  #  DEFAULT
  #    Standard comma separated format, as for RFC4180 but allowing empty lines.
  #  Settings are:
  #   withDelimiter(',')
  #   withQuote('"')
  #   withRecordSeparator("\r\n")
  #   withIgnoreEmptyLines(true)
  #
  #  EXCEL
  #    Excel file format (using a comma as the value delimiter).
  #     Note that the actual value delimiter used by Excel is locale dependent,
  #     it might be necessary to customize this format to accommodate to your regional settings.
  #     For example for parsing or generating a CSV file on a French system the following format will be used:
  #      CSVFormat fmt = CSVFormat.EXCEL.withDelimiter(';');
  #   Settings are:
  #     withSep(',')
  #     withQuote('"')
  #     withRecordSeparator("\r\n")
  #     withIgnoreEmptyLines(false)
  #     withAllowMissingColumnNames(true)
  #   Note: this is currently like RFC4180 plus withAllowMissingColumnNames(true).
  #
  #  MYSQL
  #   Default MySQL format used by the SELECT INTO OUTFILE and LOAD DATA INFILE operations.
  #   This is a tab-delimited format with a LF character as the line separator.
  #   Values are not quoted and special characters are escaped with '\'. The default NULL string is "\\N".
  #  Settings are:
  #    withSep('\t')
  #    withQuote(null)
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("\\N")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  POSTGRESQL_CSV
  #    Default PostgreSQL CSV format used by the COPY operation.
  #   This is a comma-delimited format with a LF character as the line separator.
  #   Values are double quoted and special characters are escaped with '"'. The default NULL string is "".
  #  Settings are:
  #    withSep(',')
  #    withQuote('"')
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  POSTGRESQL_TEXT
  #    Default PostgreSQL text format used by the COPY operation.
  #    This is a tab-delimited format with a LF character as the line separator.
  #    Values are double quoted and special characters are escaped with '"'. The default NULL string is "\\N".
  #  Settings are:
  #    withSep('\t')
  #    withQuote('"')
  #    withRecordSeparator('\n')
  #    withIgnoreEmptyLines(false)
  #    withEscape('\\')
  #    withNullString("\\N")
  #    withQuoteMode(QuoteMode.ALL_NON_NULL)
  #
  #  RFC4180
  #     Comma separated format as defined by RFC 4180.
  #  Settings are:
  #    withSep(',')
  #    withQuote('"')
  #    withRecordSeparator("\r\n")
  #    withIgnoreEmptyLines(false)
  #
  #  TAB
  #     Tab-separated format.
  #   Settings are:
  #     withSep('\t')
  #     withQuote('"')
  #     withRecordSeparator("\r\n")
  #     withIgnoreSurroundingSpaces(true)




  ##  e.g. use Dialect.registry[:unix] = { ... } etc.
  ##   note use @@ - there is only one registry
  def self.registry() @@registry ||={} end

  ## add built-in dialects:
  ##    trim - use strip? why? why not? use alias?
  registry[:tab]     = {}   ##{ class: TabReader }
  registry[:strict]  = { strict: true, trim: false }   ## add no comments, blank lines, etc. ???
  registry[:rfc4180] = :strict    ## alternative name
  registry[:windows] = {}
  registry[:excel]   = :windows
  registry[:unix]    = {}

  ## todo: add some more
end  # class Dialect
