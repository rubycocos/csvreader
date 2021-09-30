## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'csvjson'


## add test_data_dir helper
class CsvJson
  def self.test_data_dir
    "#{root}/datasets"
  end
end


CsvJson.logger.level = :debug   ## turn on "global" logging
