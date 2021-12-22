# encoding: utf-8


class CsvHuman


class Columns


  def self.build( values, header_converter )

    ## "clean" unify/normalize names
    keys = values.map do |value|
      if value
        if value.empty?
          nil
        else
          ## e.g. #ADM1 CODE                      => #adm1 +code
          ##      POPULATION F CHILDREN AFFECTED  => #population +affected +children +f
          tag_key = Tag.normalize( value )
          ## turn empty normalized tags (e.g. "stray" hashtag) into nil too

          if value.empty?
              nil
          else
              header_key =
              ##   todo/fix: pass in column index - why? why not?
              ##     pass in column index for all columns (or only tagged ones?) or both?
              ##   if header_converter.arity == 1  # straight converter
                     header_converter.call( tag_key )
              ##   else
              ##       header_converter.call( value, index )
              ##    end

              ## note:
              ##   return nil, "" or false to skip column
              if header_key.nil? || header_key.empty? || header_key == false   ## check again: skip empty "" columns
                nil
              else
                ##  note: return header_key (used for returned record/hash) AND tag_key (used for type conversion config)
                ## lets us fold more columns into one or splat single list/array columns into many
                [header_key,tag_key]
              end
          end
        end
      else  # keep (nil) as is
        nil
      end
    end


    counts = {}
    keys.each_with_index do |key,i|
       if key
         header_key = key[0]
         counts[header_key] ||= []
         counts[header_key] << i
       end
    end
    ## puts "counts:"
    ## pp counts


    ## create all unique tags  (used for type conversion)
    tags = {}
    keys.each do |key|
      if key
        tag_key = key[1]
        tags[tag_key] ||= Tag.parse( tag_key )  ## note: "reuse" tag for all columns if same tag key
      end
    end
    ## puts "tags:"
    ## pp tags


    cols = []
    keys.each do |key|
      if key
        header_key = key[0]
        tag_key    = key[1]

        count = counts[header_key]
        tag   = tags[tag_key]        ## note: "reuse" tag for all columns if same tag key

        if count.size > 1
          ## note: defaults to use "standard/default" tag key (as a string)
          cols << Column.new( header_key, tag, list: true )
        else
          cols << Column.new( header_key, tag )
        end
      else
        cols << Column.new
      end
    end

    cols
  end
end ## class Columns




class Column
   attr_reader  :key   # used for record (record key); note: list columns must use the same key
   attr_reader  :tag


   def initialize( key=nil, tag=nil, list: false )
     @key  = key
     @tag  = tag
     @list = list
   end


   def tagged?()  @tag.nil? == false; end
   def list?()    @list; end
end  # class Column

end # class CsvHuman
