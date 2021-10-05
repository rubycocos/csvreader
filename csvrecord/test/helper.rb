## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'csvrecord'

## add test_data_dir helper
module CsvRecord
  def self.test_data_dir
    "#{root}/test/data"
  end
end
