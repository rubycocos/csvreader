# encoding: utf-8

###
## note: to run use:
##  ruby ./io/test/test_io.rb


require 'minitest/autorun'



class TestIo  < MiniTest::Test


  def test_chomp
    ## If $/ has not been changed from the default Ruby record separator,
    ##   then chomp also removes carriage return characters
    ##   (that is it will remove \n, \r, and \r\n).

    assert_equal "line", "line".chomp
    assert_equal "line ", "line ".chomp
    assert_equal "line\r\n ", "line\r\n ".chomp

    assert_equal "line", "line\r\n".chomp
    assert_equal "line", "line\r".chomp
    assert_equal "line", "line\n".chomp
    assert_equal "line\r\n", "line\r\n\r\n".chomp
    assert_equal "line\r", "line\r\r".chomp
    assert_equal "line\n", "line\n\n".chomp

    ## If $/ is an empty string, it will remove all trailing newlines from the string.
    assert_equal "line",     "line\r\n\r\n".chomp('')
    assert_equal "line",     "line\n\n".chomp('')
    assert_equal "line\r\r", "line\r\r".chomp('')
  end

end # class TestIo
