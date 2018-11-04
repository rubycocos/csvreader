# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parser_directive.rb


require 'helper'

class TestParserDirective < MiniTest::Test


def parser
  CsvReader::Parser::DEFAULT
end


def test_iris
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


def test_lcc
  records = [['AG5',   'Encyclopedias and dictionaries.;Twentieth century.'],
             ['AS262', 'Science -- Soviet Union -- History.'],
             ['AE5',   'Encyclopedias and dictionaries.'],
             ['AS281', 'Astronomy, Assyro-Babylonian.;Moon -- Phases.'],
             ['AS281', 'Astronomy, Assyro-Babylonian.;Moon -- Tables.']]


  assert_equal records, parser.parse( <<TXT )
%  Attribute-Relation File Format (ARFF) Example
%    see https://www.cs.waikato.ac.nz/ml/weka/arff.html

@relation LCCvsLCSH

@attribute LCC string
@attribute LCSH string

@data
AG5,   'Encyclopedias and dictionaries.;Twentieth century.'
AS262, 'Science -- Soviet Union -- History.'
AE5,   'Encyclopedias and dictionaries.'
AS281, 'Astronomy, Assyro-Babylonian.;Moon -- Phases.'
AS281, 'Astronomy, Assyro-Babylonian.;Moon -- Tables.'
TXT
end

end # class TestParserDirective
