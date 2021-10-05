# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp CsvUtils::VERSION
    pp CsvUtils.banner
    pp CsvUtils.root

    assert true  ## assume ok if we get here
  end

end # class TestVersion
