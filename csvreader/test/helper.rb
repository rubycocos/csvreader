## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'csvreader'
## require 'csvreader/base'    ## try modular version (that is, without Csv,CsvHash "top-level" shortcuts)


## add test_data_dir helper
class CsvReader
  def self.test_data_dir
    "#{root}/datasets"
  end
end


## CsvReader::ParserStd.logger.level    = :debug   ## turn on "global" logging
## CsvReader::ParserStrict.logger.level = :debug   ## turn on "global" logging
## CsvReader::ParserFixed.logger.level = :debug   ## turn on "global" logging
CsvReader::ParserTable.logger.level = :debug   ## turn on "global" logging
