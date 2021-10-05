
class CsvReader

class Parser
  ## "forward" reference,
  ##     see base.rb for more
end


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
