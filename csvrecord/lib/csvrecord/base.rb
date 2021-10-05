# encoding: utf-8


module CsvRecord

########################
# Base

class Base < Record::Base

def self.foreach( path, sep: nil, headers: true )

  ## note: always use reader w/o headers to get row/record values as array of strings
  ##   if headers: true -> skip first row
  names = nil

  CsvReader.foreach( path, sep: sep ) do |row|
    if headers && names.nil?
      names = row   ## store header row / a.k.a. field/column names
    else
      rec = new
      rec.parse( row )

      yield( rec )    ## check: use block.class( rec ) - why? why not?
    end
  end
end




def self.parse( txt_or_rows, sep: nil, headers: true )  ## note: returns an (lazy) enumarator
  if txt_or_rows.is_a? String
    txt = txt_or_rows
    ## note: always use reader w/o headers to get row/record values as array of strings
    ##   if headers: true -> skip first row
    rows = CsvReader.parse( txt, sep: sep )
  else
    ### todo/fix: use only self.create( array-like ) for array-like data  - why? why not?
    rows = txt_or_rows
  end

  ## pp rows


  names = nil

  Enumerator.new do |yielder|
    rows.each do |row|
      if headers && names.nil?
        names = row   ## store header row / a.k.a. field/column names
      else
        rec = new
        rec.parse( row )

        yielder.yield( rec )
      end
    end
  end
end


def self.read( path, sep: nil, headers: true )  ## not returns an enumarator
  txt  = File.open( path, 'r:utf-8' ).read
  parse( txt, sep: sep, headers: headers )
end



def to_csv   ## use/rename/alias to to_row too - why? why not?
  ## todo/fix: check for date and use own date to string format!!!!
  @values.map{ |value| value.to_s }
end

end # class Base





###########################################
## "magic" lazy auto-build schema from headers versions

def self.build_class( headers )   ## check: find a better name - why? why not?
  ## (auto-)build record class from an array of headers
  ##   add fields (all types will be string for now)
  clazz = Class.new( Base )
  headers.each do |header|
    ## downcase and remove all non-ascii chars etc.
    ##  todo/fix: remove all non-ascii chars!!!
    ##  todo: check if header starts with a number too!!
    name = header.downcase.gsub( ' ', '_' )
    name = name.to_sym   ## symbol-ify
    clazz.field( name )
  end
  clazz
end

def self.read( path, sep: nil )
  headers = CsvReader.header( path, sep: sep )

  clazz = build_class( headers )
  clazz.read( path, sep: sep )
end

def self.foreach( path, sep: nil, &block )
  headers = CsvReader.header( path, sep: sep )

  clazz = build_class( headers )
  clazz.foreach( path, sep: sep, &block )
end


#########
# alternative class (record) builder

def self.define( &block )   ## check: rename super_class to base - why? why not?
  Record.define( Base, &block )
end

end # module CsvRecord
