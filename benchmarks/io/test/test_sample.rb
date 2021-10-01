# encoding: utf-8

###
## note: to run use:
##  ruby ./io/test/test_sample.rb


require 'minitest/autorun'


require_relative '../helper'


class TestSample  < MiniTest::Test

  def recs
    [["Date", "Open", "High", "Low", "Close", "Adj Close", "Volume"],
     ["2018-01-02", "86.129997", "86.309998", "85.500000", "85.949997", "84.487411", "22483800"],
     ["2018-01-03", "86.059998", "86.510002", "85.970001", "86.349998", "84.880608", "26061400"],
     ["2018-01-04", "86.589996", "87.660004", "86.570000", "87.110001", "85.627678", "21912000"],
     ["2018-01-05", "87.660004", "88.410004", "87.430000", "88.190002", "86.689301", "23407100"],
     ["2018-01-08", "88.199997", "88.580002", "87.599998", "88.279999", "86.777763", "22113000"]]
  end


  def test_readline_sample
    assert_equal recs, readline_sample[0..5]
  end

  def test_readline_inplace_sample
    assert_equal recs, readline_inplace_sample[0..5]
  end

  def test_readline_scanner_sample
    assert_equal recs, readline_scanner_sample[0..5]
  end

  def test_readchar_sample
    assert_equal recs, readchar_sample[0..5]
  end


  def test_parse_scanner_scanner_sample
    assert_equal recs, parse_scanner_scanner_sample[0..5]
  end
end # class TestSample
