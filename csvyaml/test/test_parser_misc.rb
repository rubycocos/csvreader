# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_misc.rb


require 'helper'

class TestParserMisc < MiniTest::Test


def parser
  CsvYaml
end


def test_quotes_and_commas
  assert_equal [
    [1, "John", "12 Totem Rd., Aspen", true],
    [2, "Bob",  nil,                   false],
    [3, "Sue", "\"Bigsby\", 345 Carnival, WA 23009", false]
    ], parser.parse( <<TXT )
  1,John,"12 Totem Rd., Aspen",true
  2,Bob,null,false
  3,Sue,"\\"Bigsby\\", 345 Carnival, WA 23009",false
TXT
end


def test_arrays
  assert_equal [
    [1, "directions", ["north","south","east","west"]],
    [2, "colors", ["red","green","blue"]],
    [3, "drinks", ["soda","water","tea","coffe"]],
    [4, "spells", []],
  ], parser.parse( <<TXT )
  # CSV <3 YAML with array values

  1,directions,[north,south,east,west]
  2,colors,[red,green,blue]
  3,drinks,[soda,water,tea,coffe]
  4,spells,[]
TXT
end

def test_misc
  ## note:
  ##   in the csv <3 json source text backslash needs to get doubled / escaped twice e.g.
  ##   \\"  for quotes
  ##   \\n  for newlines and so on

  assert_equal [
    ["index", "value1", "value2"],
    ["number", 1, 2],
    ["boolean", false, true],
    ["null", nil, "non null"],
    ["array of numbers", [1], [1,2]],
    ["simple object", {"a" => 1}, {"a" => 1, "b" => 2}],
    ["array with mixed objects", [1, nil,"ball"], [2,{"a" => 10, "b" => 20},"cube"]],
    ["string with quotes", "a\"b", "alert(\"Hi!\")"],
    ["string with bell&newlines","bell is \u0007","multi\nline\ntext"]
  ], parser.parse( <<TXT )
  # CSV with all kinds of values

  index,value1,value2
  number,1,2
  boolean,false,true
  "null",null,non null
  array of numbers,[1],[1,2]
  ## note: key:value pairs need a space after colon!!! NOT working {a:1},{a:1, b:2}
  simple object,{a: 1},{a: 1, b: 2}
  ## note: again - key:value pairs need a space after colon!!! NOT working {a:10, b:20}
  array with mixed objects,[1,null,ball],[2,{a: 10,b: 20},cube]
  string with quotes,"a\\"b","alert(\\"Hi!\\")"
  string with bell&newlines,"bell is \\u0007","multi\\nline\\ntext"
TXT

end


end # class TestParserMisc
