## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'tabreader'

## add test_data_dir helper
class TabReader
  def self.test_data_dir
    "#{root}/datasets"
  end
end



TabReader.logger.level = :debug   ## turn on "global" logging
