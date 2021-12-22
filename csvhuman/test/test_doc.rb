# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_doc.rb


require 'helper'

class TestDoc < MiniTest::Test

include CsvHuman::DocHelper


## def test_read
##  pp CsvHuman::Doc.read_attributes( "./scripts/pages/attributes.txt" )
##  pp CsvHuman::Doc.read_tags( "./scripts/pages/tags.txt" )
## end



def test_match_hashtag
  m=match_hashtag( '#org' )
  assert_equal 'org', m[:name]
end

def test_match_attribute
  m=match_attribute( '+f' )
  assert_equal 'f', m[:name]
end

def test_parse_attributes
  doc = CsvHuman::Doc.new( <<TXT )
  2.1. Sex- and-age disaggregation (SADD) attributes
  +adolescents
  Adolescents, loosely defined (precise age range varies); may overlap +children and +adult. You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "+adolescents +age12_17". Since HXL 1.0

  Associated hashtags
  #affected
  People/households affected
  #inneed
  People/households in need of assistance
  #population
  General population
  #reached
  People/households reached with assistance
  #targeted
  People/households targeted for assistance

  +adults
  Adults, loosely defined (precise age range varies); may overlap +adolescents and +elderly. You can optionally create custom attributes in addition to this to add precise age ranges, e.g. "+adults +age18_64". Since HXL 1.0

  Associated hashtags
  #affected
  People/households affected
  #inneed
  People/households in need of assistance
  #population
  General population
  #reached
  People/households reached with assistance
  #targeted
  People/households targeted for assistance
TXT

  attributes =
   [["adolescents",
     "1.0",
     "(1) Sex- and-age disaggregation (SADD) attributes",
     "#affected #inneed #population #reached #targeted",
     "Adolescents, loosely defined (precise age range varies); may overlap +children and +adult. You can optionally create custom attributes in addition to this to add precise age ranges, e.g. \"+adolescents +age12_17\"."],
    ["adults",
     "1.0",
     "(1) Sex- and-age disaggregation (SADD) attributes",
     "#affected #inneed #population #reached #targeted",
     "Adults, loosely defined (precise age range varies); may overlap +adolescents and +elderly. You can optionally create custom attributes in addition to this to add precise age ranges, e.g. \"+adults +age18_64\"."]]

  assert_equal attributes, doc.parse_attributes
end


def test_parse_tags
  doc = CsvHuman::Doc.new( <<TXT )
  1.1. Places
  #adm1
  Top-level subnational administrative area (e.g. a governorate in Syria). Since HXL 1.0.

  Suggested attributes for #adm1
  +code
  Is a code or ID
  +dest
  Is a destination (place)
  +name
  Is a name or title
  +origin
  Is a place of origin

  #adm2
  Second-level subnational administrative area (e.g. a subdivision in Bangladesh). Since HXL 1.0.

  Suggested attributes for #adm2
  +code
  Is a code or ID
  +dest
  Is a destination (place)
  +name
  Is a name or title
  +origin
  Is a place of origin
TXT

  tags =
   [["adm1",
     nil,
     "1.0",
     "(1) Places",
     "+code +dest +name +origin",
     "Top-level subnational administrative area (e.g. a governorate in Syria)."],
    ["adm2",
     nil,
     "1.0",
     "(1) Places",
     "+code +dest +name +origin",
     "Second-level subnational administrative area (e.g. a subdivision in Bangladesh)."]]

  assert_equal tags, doc.parse_tags
end

end # class TestDoc
