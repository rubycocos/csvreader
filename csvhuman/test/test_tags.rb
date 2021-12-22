# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_tags.rb


require 'helper'

class TestTags < MiniTest::Test

def split( value )
  CsvHuman::Tag.split( value )  ## returns an array of strings (name+attributes[])
end

def normalize( value )
  CsvHuman::Tag.normalize( value )   ## returns a string
end

def parse( value )
  CsvHuman::Tag.parse( value )   ## returns a Tag class
end



def test_split
  assert_equal [], split( "" )   # empty
  assert_equal [], split( "     " )   # empty

  ## more empties (all matched by separator regex/pattern)
  ##   keep as empty - why? why not?
  assert_equal [], split( " #    " )   # empty
  assert_equal [], split( " ##   " )   # empty
  assert_equal [], split( " +   " )   # empty
  assert_equal [], split( " +++ " )   # empty
  assert_equal [], split( " +++## " )   # empty


  assert_equal ["sector", "en"], split( "#sector+en" )
  assert_equal ["sector", "en"], split( "#SECTOR EN" )
  assert_equal ["sector", "en"], split( "  # SECTOR  + EN " )
  assert_equal ["sector", "en"], split( "SeCtOr en" )
  assert_equal ["sector", "en"], split( "#sector#en" )
  assert_equal ["sector", "en"], split( "#sector+#en" )  ## allow (optional) hash for attributes
  assert_equal ["sector", "en"], split( "##sector#en" )  ## allow hash only for attributes
  assert_equal ["sector", "en"], split( "# #sector+++ ##en" )  ## allow one or more plus or hashes (typos) for attibutes


  assert_equal ["adm1", "code"], split( "#ADM1 +CODE" )
  assert_equal ["adm1", "code"], split( " # ADM1 + CODE" )
  assert_equal ["adm1", "code"], split( "ADM1 CODE" )

  ## sort attributes a-to-z
  assert_equal ["affected", "children", "f"], split( "#affected +f +children" )
  assert_equal ["population", "affected", "children", "m"], split( "#population +children +affected +m" )
  assert_equal ["population", "affected", "children", "m"], split( "#population+children+affected+m" )
  assert_equal ["population", "affected", "children", "m"], split( "#population+#children+#affected+#m" )
  assert_equal ["population", "affected", "children", "m"], split( "#population #children #affected #m" )
  assert_equal ["population", "affected", "children", "m"], split( "POPULATION CHILDREN AFFECTED M" )
end


def test_normalize
  assert_equal "", normalize( "" )   # empty
  assert_equal "", normalize( "   " )   # empty

  assert_equal "#sector +en", normalize( "#sector+en" )
  assert_equal "#sector +en", normalize( "#SECTOR EN" )
  assert_equal "#sector +en", normalize( "  # SECTOR  + EN " )
  assert_equal "#sector +en", normalize( "  # SECTOR  # EN " )
  assert_equal "#sector +en", normalize( "SeCToR en" )

  assert_equal "#adm1 +code", normalize( "#ADM1 +CODE" )
  assert_equal "#adm1 +code", normalize( " # ADM1 + CODE" )
  assert_equal "#adm1 +code", normalize( " # ADM1 + #CODE" )
  assert_equal "#adm1 +code", normalize( "ADM1 Code" )

  ## sort attributes a-to-z
  assert_equal "#affected +children +f", normalize( "#affected +f +children" )
  assert_equal "#population +affected +children +m", normalize( "#population +children +affected +m" )
  assert_equal "#population +affected +children +m", normalize( "#population+children+affected+m" )
  assert_equal "#population +affected +children +m", normalize( "POPULATION CHILDREN AFFECTED M" )
end


def test_parse
  tag = parse( "#sector+en" )
  assert_equal "#sector +en", tag.to_s
  assert_equal "sector",      tag.name
  assert_equal ["en"],        tag.attributes
  assert_equal String,        tag.type

  assert_equal "#sector +en", parse( "#SECTOR EN" ).to_s
  assert_equal "#sector +en", parse( "  # SECTOR  + EN " ).to_s


  tag = parse( "#adm1" )
  assert_equal "#adm1", tag.to_s
  assert_equal "adm1",  tag.name
  assert_equal [],      tag.attributes
  assert_equal String,  tag.type

  assert_equal "#adm1", parse( "ADM1" ).to_s
end

end # class TestTags
