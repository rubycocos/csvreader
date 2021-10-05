## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'csvutils'

## add test_data_dir helper
class CsvUtils
  def self.test_data_dir
    "#{root}/datasets"
  end
end
