# encoding: utf-8

require 'csvreader'



def linkify_tag( tag )
  "[`##{tag}`](##{tag})"
end


ATTRIBUTE_RX = /
               \+[a-z][a-z0-9_]*
             /x

HASHTAG_RX = /
               \#[a-z][a-z0-9]+
             /x

def linkify_hashtags( line )
  ## note: assumes #adm1 etc. (that is, includes leading hashtag)
  line.gsub( HASHTAG_RX ) do |hashtag|
    puts "linkify hashtag >#{hashtag}<"
    "[`#{hashtag}`](#{hashtag})"
  end
end

def linkify_attributes( line, page: '' )
  ## note: assumes +f etc. (that is, includes leading plus)
  line.gsub( ATTRIBUTE_RX ) do |attrib|
    puts "linkify attribute >#{attrib}<"
    if attrib.index( '_' )
      "`#{attrib}`"    ## note: do NOT linkify custom attributes for now (if include underscore e.g. +age12_17 etc.)
    else
      "[`#{attrib}`](#{page}##{attrib[1..-1]})"  ## note: cut-of leading + in intralink
    end
  end
end




def build_summary( tags )
  pp tags

  tags_a_to_z = tags.sort { |l,r|  l['tag'] <=> r['tag'] }
  pp tags_a_to_z


  buf = ""
  buf << "# Humanitarian eXchangle Language (HXL) Tags\n\n"

  tags_a_to_z.each do |tag|
    buf << linkify_tag( tag['tag'])
    buf << "\n"
  end

  buf << "\n\n"



  last_category = nil

  tags.each do |tag|

    if tag['category'] != last_category
      buf << "## #{tag['category']}\n\n"
    end

    buf << "### `##{tag['tag']}`\n\n"
    buf << "#{linkify_hashtags(tag['description'])}"
    buf << " "
    buf << "_Since version #{tag['since']}_\n\n"

    unless tag['type'].empty?
      buf << "Every value must be a **#{tag['type']}**.\n\n"
    end

    unless tag['attributes'].empty?
      buf << "Attributes: #{linkify_attributes(tag['attributes'], page: 'ATTRIBUTES.md')}\n\n"
    end


    last_category = tag['category']
  end

  buf
end


## pp Csv.read( "./config/tags.csv" )

tags = CsvHash.read( "./config/tags.csv" )

buf = build_summary( tags )
puts buf

File.open( "./TAGS.md", 'w:utf-8') do |f|
  f.write( buf )
end
