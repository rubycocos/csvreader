# encoding: utf-8

class CsvHuman
class Doc    ## tags and attributes (schema) reader / converter (txt to csv)
  include DocHelper



def self.read_attributes( path )
  self.open( path ) { |doc| doc.parse_attributes }
end

def self.read_tags( path )
  self.open( path ) { |doc| doc.parse_tags }
end

def self.open( path, mode=nil, &block )   ## rename path to filename or name - why? why not?

   ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
   f  = File.open( path, mode ? mode : 'r:bom|utf-8' )
   doc = self.new( f )

   # handle blocks like Ruby's open(), not like the (old old) CSV library
   if block_given?
     begin
       block.call( doc )
     ensure
       f.close
     end
   else
     doc    ## note: caller responsible for closing (todo/fix: add close,closed? to doc!!!)
   end
end # method self.open




def initialize( str_or_readable )
  # note: must (only) support/respond_to read_line
  @input = str_or_readable
end


def parse_attributes

  attrib   = nil
  category = nil
  descr    = nil
  version  = nil
  tags     = []

  next_line   =  nil   ## e.g. set to :descr

  attribs = []

  @input.each_line do |line|
    line = line.chomp( '' )

    line = line.strip   ## remove leading and trailing spaces


    next if line.empty? || line.start_with?( '%' )   ## skip blank lines and comment lines

    if next_line == :descr
      ## auto-capture next line (if descr reset to nil)
      descr, version = split_descr( line )
      puts "descr >#{descr}<, version >#{version}<"

      next_line = nil
    elsif (m=match_heading( line ))
      ## note: new category ends attribute definition
      if attrib
        attribs << [attrib, version, category, tags.join( ' ' ), descr]
        attrib = nil
      end

      category = "(#{m[:level2]}) #{m[:title]}"
    elsif (m=match_attribute( line ))
      if attrib
        attribs << [attrib, version, category, tags.join( ' ' ), descr]
      end

      attrib    = m[:name]
      tags      = []
      descr     = nil
      version   = nil

      next_line = :descr  ## reset descr to nil - will auto-capture next line
    elsif (m=match_hashtag( line ))
      tags << "##{m[:name]}"
    end
  end

  if attrib
    attribs << [attrib, version, category, tags.join( ' ' ), descr]
  end

  attribs
end  # method parse_attributes



def parse_tags

  tag     = nil
  type    = nil
  category = nil
  descr    = nil
  version  = nil
  attribs  = []

  next_line   =  nil   ## e.g. set to :descr


  tags = []

  @input.each_line do |line|
    line = line.chomp( '' )

    line = line.strip   ## remove leading and trailing spaces


    next if line.empty? || line.start_with?( '%' )   ## skip blank lines and comment lines

    if next_line == :descr
      ## auto-capture next line (if descr reset to nil)
      descr, version = split_descr( line )

      ## descr = "(2) People and households"   if descr == "(2) Surveys and assessments"

      puts "descr >#{descr}<, version >#{version}<"

      next_line = nil
    elsif (m=match_heading( line ))
      ## note: new category ends tag definition
      if tag
        tags << [tag, type, version, category, attribs.join( ' ' ), descr]
        tag = nil
      end

      category = "(#{m[:level2]}) #{m[:title]}"
    elsif (m=match_type( line ))
      type = m[:type]
    elsif (m=match_hashtag( line ))
      if tag
        tags << [tag, type, version, category, attribs.join( ' ' ), descr]
      end

      tag      = m[:name]
      attribs  = []
      type     = nil
      descr    = nil
      version  = nil

      next_line = :descr  ## reset descr to nil - will auto-capture next line
    elsif (m=match_attribute( line ))
      attribs << "+#{m[:name]}"
    end
  end

  if tag
    tags << [tag, type, version, category, attribs.join( ' ' ), descr]
  end

  tags
end  # method  parse_tags

end  # class Doc
end  # class CsvHuman
