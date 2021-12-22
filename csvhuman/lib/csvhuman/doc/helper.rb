# encoding: utf-8

class CsvHuman
module DocHelper


HASHTAG_LINE_RX= /^
                   \s*
                   \#
                   (?<name>[a-z][a-z0-9]+)
                   \s*
                   $/x

def match_hashtag( line )
   if (m=HASHTAG_LINE_RX.match(line))
     puts "hashtag >#{m[:name]}<"
     m
   else
     nil
   end
end



## note: attrib might be one letter only (e.g.) +m,+f, etc.
ATTRIBUTE_LINE_RX= /^
                   \s*
                   \+
                   (?<name>[a-z][a-z0-9]*)
                   \s*
                   $/x

def match_attribute( line )
   if (m=ATTRIBUTE_LINE_RX.match(line))
     puts "attrib >#{m[:name]}<"
     m
   else
     false
   end
end



##
## e.g. 1.1. Places
##      2.1. Sex- and-age disaggregation (SADD) attributes

HEADING_LINE_RX=/^
                   \s*
                   (?<level1>[1-9])
                     \.
                   (?<level2>[1-9])
                     \.
                     \s+
                    (?<title>.+?)
                     \s*
                   $/x

def match_heading( line )
  if (m=HEADING_LINE_RX.match(line))
    puts "heading #{m[:level1]}.#{m[:level2]}. (#{m[:level2]}) >#{m[:title]}<"
    m
  else
    false
  end
end



TYPE_RX = /Every value must be a (?<type>[a-z]+)./
def match_type( line )
  if (m=TYPE_RX.match(line))
    puts "type: >#{m[:type]}<"
    m
  else
    false
  end
end



SINCE_HXL_RX = /Since HXL (?<version>[1]\.[0-9])\.?/
def match_since_hxl( line )
  if (m=SINCE_HXL_RX.match(line))
    puts "version: >#{m[:version]}<"
    m
  else
    false
  end
end



def split_descr( line )
  if( m=match_since_hxl( line ))
    version = m[:version]
    ## remove "Since HXL 1.0" from text
    text    = line.gsub( SINCE_HXL_RX, '' ).strip
  else
    version = '?'
    text = line
  end
  [text,version]
end


end # module DocHelper
end # class CsvHuman
