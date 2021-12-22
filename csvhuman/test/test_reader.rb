# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'

class TestReader < MiniTest::Test

def recs
   [["Organisation", "Cluster", "Province" ],
     [ "#org", "#sector", "#adm1" ],
     [ "Org A", "WASH", "Coastal Province" ],
     [ "Org B", "Health", "Mountain Province" ],
     [ "Org C", "Education", "Coastal Province" ],
     [ "Org A", "WASH", "Plains Province" ]]
end

def recs2
   [["Organisation", "Cluster", "Province" ],
     [ "ORG", "#SECTOR", "ADM1" ],
     [ "Org A", "WASH", "Coastal Province" ],
     [ "Org B", "Health", "Mountain Province" ],
     [ "Org C", "Education", "Coastal Province" ],
     [ "Org A", "WASH", "Plains Province" ]]
end


def expected_recs
  [{"org"=>"Org A", "sector"=>"WASH",      "adm1"=>"Coastal Province"},
   {"org"=>"Org B", "sector"=>"Health",    "adm1"=>"Mountain Province"},
   {"org"=>"Org C", "sector"=>"Education", "adm1"=>"Coastal Province"},
   {"org"=>"Org A", "sector"=>"WASH",      "adm1"=>"Plains Province"}]
end




def txt
  <<TXT
  What,,,Who,Where,For whom,
  Record,Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion
  ,#sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
  001,WASH,Subsector 1,Org 1,Country 1,100,100,Region 1
  002,Health,Subsector 2,Org 2,Country 2,,,Region 2
  003,Education,Subsector 3,Org 3,Country 2,250,300,Region 3
  004,WASH,Subsector 4,Org 1,Country 3,80,95,Region 4
TXT
end

def txt2
  <<TXT
  %%%%%%%
  % some comments here
  %  note: you can use blank lines and/or leading and trailing spaces

  What,                 ,         , Who        ,Where  ,For whom,
  Record, Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion

  ,       #sector+en, #subsector, #org, #country, #sex+#targeted, #sex+#targeted, #adm1

  %%%
  % more comments here

  001, WASH,      Subsector 1, Org 1, Country 1, 100, 100, Region 1
  002, Health,    Subsector 2, Org 2, Country 2,    ,    , Region 2
  003, Education, Subsector 3, Org 3, Country 2, 250, 300, Region 3
  004, WASH,      Subsector 4, Org 1, Country 3,  80,  95, Region 4

  %%%
  % some more comments and blank lines


TXT
end

def txt3
  <<TXT
  %%%%%%%%%%%%%%%%%
  %  use semicolon (;) as sep(arator)

  What;;;Who;Where;For whom;
  Record;Sector/Cluster;Subsector;Organisation;Country;Males;Females;Subregion
  ;#sector+en;#subsector;#org;#country;#sex+#targeted;#sex+#targeted;#adm1
  001;WASH;Subsector 1;Org 1;Country 1;100;100;Region 1
  002;Health;Subsector 2;Org 2;Country 2;;;Region 2
  003;Education;Subsector 3;Org 3;Country 2;250;300;Region 3
  004;WASH;Subsector 4;Org 1;Country 3;80;95;Region 4
TXT
end



def expected_recs2
  [
  {"sector+en"    => "WASH",
   "subsector"    => "Subsector 1",
   "org"          => "Org 1",
   "country"      => "Country 1",
   "sex+targeted" => [100, 100],
   "adm1"         => "Region 1"},
  {"sector+en"    => "Health",
   "subsector"    => "Subsector 2",
   "org"          => "Org 2",
   "country"      => "Country 2",
   "sex+targeted" => [nil, nil],
   "adm1"         => "Region 2"},
  {"sector+en"    => "Education",
   "subsector"    => "Subsector 3",
   "org"          => "Org 3",
   "country"      => "Country 2",
   "sex+targeted" => [250, 300],
   "adm1"         => "Region 3"},
  {"sector+en"    => "WASH",
   "subsector"    => "Subsector 4",
   "org"          => "Org 1",
   "country"      => "Country 3",
   "sex+targeted" => [80, 95],
   "adm1"         => "Region 4"}]
end


def test_basics
  csv = CsvHuman.new( recs )
  csv.each do |rec|
    pp rec
  end

  assert_equal expected_recs, CsvHuman.parse( recs )
  assert_equal expected_recs, CsvHuman.parse( recs2 )

  CsvHuman.parse( recs ).each do |rec|
    pp rec
  end


  pp CsvHuman.read( "#{CsvHuman.test_data_dir}/test.csv" )


  assert_equal expected_recs2, CsvHuman.parse( txt )
  assert_equal expected_recs2, CsvHuman.parse( txt2 )


  CsvHuman.parse( txt ).each do |rec|
    pp rec
  end

  CsvHuman.foreach( "#{CsvHuman.test_data_dir}/test.csv" ) do |rec|
    pp rec
  end
end


def test_header_converter
  pp CsvHuman.parse( txt2, :header_converter => :default )
  pp CsvHuman.parse( txt2, :header_converter => :none )
  pp CsvHuman.parse( txt2, :header_converter => :symbol )

  pp CsvHuman.parse( txt2, header_converter: ->(value) { value.upcase } )
end


def test_semicolon
  assert_equal expected_recs2, CsvHuman.parse( txt3, sep: ';' )  ## try with semicolon (;)
end


end # class TestReader
