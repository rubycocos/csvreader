# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader_hash_converters.rb


require 'helper'

class TestReaderHashConverters < MiniTest::Test


def test_nil
  ## default no converters
  rows = CsvHashReader.parse( <<TXT )
a,b,c
1,2,3
true,false,null
,,
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal( {'a'=>'1',   'b'=>'2',    'c'=>'3'},    rows[0] )
  assert_equal( {'a'=>'true','b'=>'false','c'=>'null'}, rows[1] )
  assert_equal( {'a'=>'',    'b'=>'',     'c'=>'' },    rows[2] )
end


def test_all
  rows = CsvHashReader.parse( <<TXT, :converters => :all )
a,b,c
1,2,3
true,false,null
,,
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal( {'a'=>1,   'b'=>2,    'c'=>3},   rows[0] )
  assert_equal( {'a'=>true,'b'=>false,'c'=>nil}, rows[1] )
  assert_equal( {'a'=>nil, 'b'=>nil,  'c'=>nil}, rows[2] )
end


def test_downcase
  rows = CsvHashReader.parse( <<TXT, :converters => :all, :header_converters => :downcase )
A,B,C
1,2,3
true,false,null
,,
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal( {'a'=>1,   'b'=>2,    'c'=>3},   rows[0] )
  assert_equal( {'a'=>true,'b'=>false,'c'=>nil}, rows[1] )
  assert_equal( {'a'=>nil, 'b'=>nil,  'c'=>nil}, rows[2] )
end


def test_symbol
  rows = CsvHashReader.parse( <<TXT, :converters => :all, :header_converters => :symbol )
a,b,c
1,2,3
true,false,null
,,
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal( {a: 1,    b: 2,     c: 3},   rows[0] )
  assert_equal( {a: true, b: false, c: nil}, rows[1] )
  assert_equal( {a: nil,  b: nil,   c: nil}, rows[2] )
end



def test_all_quotes
  ## only convert unquoted values - why? why not?
  ##   e.g.  1      =>  1 (integer)
  ##         "1"    => "1" (string)
  ##         true   => true (boolean)
  ##         "true" => "true" (string)
  ##
  ##
  ##  note: use CsvRecord for by column types / converters

  rows = CsvHashReader.parse( <<TXT, :converters => :all )
"a","b","c"
"1","2","3"
"true","false","null"
"","",""
TXT

  pp rows

  assert_equal 3, rows.size
  assert_equal( {'a'=>1,   'b'=>2,    'c'=>3},   rows[0] )
  assert_equal( {'a'=>true,'b'=>false,'c'=>nil}, rows[1] )
  assert_equal( {'a'=>nil, 'b'=>nil,  'c'=>nil}, rows[2] )
end


end # class TestHashReaderConverters
