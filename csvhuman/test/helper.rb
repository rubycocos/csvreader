## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
## require 'csvhuman/base'
require 'csvhuman'


## add test_data_dir helper
class CsvHuman
  def self.test_data_dir
    "#{root}/test/data"
  end
end
