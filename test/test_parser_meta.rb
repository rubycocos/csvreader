# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_meta.rb


require 'helper'

class TestParserMeta < MiniTest::Test


def parser
  CsvReader::Parser::DEFAULT
end


def test_parse
  records = [["a", "b", "c"],
             ["1", "2", "3"]]

  assert_equal records, parser.parse( <<TXT )
# with meta data
## see https://blog.datacite.org/using-yaml-frontmatter-with-csv/
---
columns:
- title: Purchase Date
  type: date
- title: Item
  type: string
- title: Amount (€)
  type: float
---
a,b,c
1,2,3
TXT

  pp parser.meta
  meta = { "columns"=>
             [{"title"=>"Purchase Date", "type"=>"date"},
              {"title"=>"Item",          "type"=>"string"},
              {"title"=>"Amount (€)",    "type"=>"float"}]
         }
  assert_equal meta, parser.meta


  assert_equal records, parser.parse( <<TXT )
# with (empty) meta data
---
---
a,b,c
1,2,3
TXT

  pp parser.meta
  meta = {}
  assert_equal meta, parser.meta



  assert_equal records, parser.parse( <<TXT )
# without meta data
a,b,c
1,2,3
TXT

  assert_nil parser.meta
end


end # class TestParserMeta
