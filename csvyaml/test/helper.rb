## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'csvyaml'


## add test_data_dir helper
class CsvYaml
  def self.test_data_dir
    "#{root}/datasets"
  end
end


CsvYaml.logger.level = :debug   ## turn on "global" logging
