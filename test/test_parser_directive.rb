# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_directive.rb


require 'helper'

class TestParserDirective < MiniTest::Test


def parser
  parser = CsvReader::Parser::DEFAULT
end


def test_parse
  records = [["5.1","3.5","1.4","0.2","Iris-setosa"],
             ["4.9","3.0","1.4","0.2","Iris-setosa"]]


  assert_equal records, parser.parse( <<TXT )
% with meta data - arff (attribute relation file format)-style
%

@RELATION iris

@ATTRIBUTE sepallength NUMERIC
@ATTRIBUTE sepalwidth NUMERIC
@ATTRIBUTE petallength NUMERIC
@ATTRIBUTE petalwidth NUMERIC
@ATTRIBUTE class {Iris-setosa,Iris-versicolor,Iris-virginica}

@DATA
5.1,3.5,1.4,0.2,Iris-setosa
4.9,3.0,1.4,0.2,Iris-setosa
TXT
end


end # class TestParserDirective
