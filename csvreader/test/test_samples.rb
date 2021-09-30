# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_samples.rb


require 'helper'

class TestSamples < MiniTest::Test


def test_cities11
  records = CsvReader.read( "#{CsvReader.test_data_dir}/cities11.csv" )
  pp records

  assert_equal [["Los Angeles",   "34°03'N",      "118°15'W"],
                ["New York City", %Q{40°42'46"N}, %Q{74°00'21"W}],
                ["Paris",         %Q{48°51'24"N}, %Q{2°21'03"E}]], records
end


def test_cars11
  records = CsvReader.read( "#{CsvReader.test_data_dir}/cars11.csv" )
  pp records

  assert_equal [["Year", "Make",  "Model",  "Description", "Price"],
                ["1997", "Ford",  "E350",   "ac, abs, moon", "3000.00"],
                ["1999", "Chevy", %Q{Venture "Extended Edition"}, "", "4900.00"],
                ["1999", "Chevy", %Q{Venture "Extended Edition, Very Large"}, "", "5000.00"],
                ["1996", "Jeep",  "Grand Cherokee", "MUST SELL!\nair, moon roof, loaded", "4799.00"]], records
end


def test_customers11
  records = CsvReader.read( "#{CsvReader.test_data_dir}/customers11.csv" )
  pp records

  assert_equal [["Name",   "Times arrived", "Total $ spent", "Food feedback"],
                ["Dan",      "34", "2548", "Lovin it!"],
                ["Maria",    "55", "5054", "Good, delicious food"],
                ["Carlos",   "22", "4352", %Q{I am "pleased", but could be better}],
                ["Stephany", "34", "6542", "I want bigger steaks!!!!!"],
                ["James",    "1",    "43", "Not bad"],
                ["Robin",    "1",    "56", "Fish is tasty"],
                ["Anna",     "1",    "79", "Good, better, the best!"]], records
end

def test_shakespeare11
  records = CsvReader.read( "#{CsvReader.test_data_dir}/shakespeare.csv" )
  pp records

  assert_equal [["Quote", "Play", "Cite"],
                ["Sweet are the uses of adversity", "As You Like It", "Act 2, scene 1, 12"],
                ["All the world's a stage", "As You Like It", "Act 2, scene 7, 139"],
                ["We few, we happy few", "Henry V", ""],
                [%Q{"Seems," madam! Nay it is; I know not "seems."}, "Hamlet", "(1.ii.76)"],
                ["To be, or not to be", "Hamlet", "Act 3, scene 1, 55"],
                ["What's in a name? That which we call a rose by any other name would smell as sweet.", "Romeo and Juliet", "(II, ii, 1-2)"],
                ["O Romeo, Romeo, wherefore art thou Romeo?", "Romeo and Juliet", "Act 2, scene 2, 33"],
                ["Tomorrow, and tomorrow, and tomorrow", "Macbeth", "Act 5, scene 5, 19"]], records
end


def test_test
  records = CsvReader.read( "#{CsvReader.test_data_dir}/test.csv" )
  pp records

  assert_equal [["A", "B", "C", "D"],
                ["a", "b", "c", "d"],
                ["e", "f", "g", "h"],
                [" i ", " j ", " k ", " l "],
                ["", "", "", ""],
                ["", "", "", ""]], records
end


end # class TestSamples
