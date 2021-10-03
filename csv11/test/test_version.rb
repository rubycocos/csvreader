# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'


class TestVersion < MiniTest::Test


  def test_version

    puts Values::VERSION
    assert true
    ## assume everything ok if get here
  end

end # class TestVersion
