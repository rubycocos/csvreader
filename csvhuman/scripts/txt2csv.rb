# encoding: utf-8

require 'csvhuman'


def csv_row( *values )
  values.map do |value|
     if value && (value.index(",") || value.index('"'))
       ## double quotes and enclose in double qoutes
       value = %Q{"#{value.gsub('"', '""')}"}
     else
       value
     end
  end
end


attribs = CsvHuman::Doc.read_attributes( "./scripts/pages/attributes.txt" )
pp attribs

File.open( "./config/attributes.csv", 'w:utf-8') do |f|
 f.write ["attribute","since","category","tags","description"].join(",")
 f.write "\n"
 attribs.each do |attrib|
   f.write csv_row(*attrib).join(",")
   f.write "\n"
 end
end


tags = CsvHuman::Doc.read_tags( "./scripts/pages/tags.txt" )
pp tags

File.open( "./config/tags.csv", 'w:utf-8') do |f|
 f.write ["tag", "type", "since", "category", "attributes", "description"].join(",")
 f.write "\n"
 tags.each do |tag|
  f.write csv_row(*tag).join(",")
  f.write "\n"
 end
end
