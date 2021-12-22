# encoding: utf-8


class CsvHuman

HEADER_CONVERTERS = {
 ## e.g.  "#adm1 +code"  =>  "#adm1 +code"
 none:      ->(value) { value },

 ## e.g.  "#adm1 +code"  =>  "adm1+code"   (strip hashtags and whitespace)
 default:   ->(value) { value.downcase.gsub('#', '').
                                       gsub( /\s+/, '' ) },

 ## e.g.  "#adm1 +code"  =>  :adm1_code"   (strip hashtags and whitespace and turn plus (+) into underscore (_))
 symbol:    ->(value) { value.downcase.gsub('#', '').
                                       gsub( /\s+/, '' ).
                                       gsub('+', '_').
                                       gsub( /[^\w]+/, '' ).to_sym }
}




  def self.guess_type( name, attributes )
    if name == 'date'
       if attributes.include?( 'year' )
         Integer    ##  just the year (e.g. 2011); use an integer number
       else
         Date
       end
    ## todo/fix: add more well-known names with num required!!!
    elsif ['affected', 'inneed', 'targeted', 'reached', 'population'].include?( name )
       Integer
    else
      ## check attributes
      if attributes.nil? || attributes.empty?
        String  ## assume (default to) string
      elsif attributes.include?( 'num' ) ||
            attributes.include?( 'id')   ## assume id is (always) a rowid - why? why not?
        Integer
      elsif attributes.include?( 'date' )   ### todo/check: exists +date?
        Date
      elsif name == 'geo' && (attributes.include?('lat') ||
                              attributes.include?('lon') ||
                              attributes.include?('elevation'))
        Float
      elsif attributes.include?( 'killed' ) ||
            attributes.include?( 'injured' ) ||
            attributes.include?( 'infected' ) ||
            attributes.include?( 'displaced' ) ||
            attributes.include?( 'idps' ) ||
            attributes.include?( 'refugees' ) ||
            attributes.include?( 'abducted' ) ||
            attributes.include?( 'threatened' ) ||
            attributes.include?( 'affected' ) ||
            attributes.include?( 'inneed' ) ||
            attributes.include?( 'targeted' ) ||
            attributes.include?( 'reached' )
        Integer
      else
        String   ## assume (default to) string
      end
    end
  end


## convert guess_type to proc (is there a better/idomatic way)?
#   ->(name, attributes) { guess_type( name, attributes ) }
## TYPE_MAPPING_GUESS = Kernel.method( :guess_type )

TYPE_MAPPINGS = {
  ##  always returns string (that is, keep as is (assumes always string values))
  none:      ->(name, attributes) { String },
  guess:     ->(name, attributes) { guess_type( name, attributes ) },
}

## add aliases  (check - is there a better/idomatic way?)
TYPE_MAPPINGS[ :default] = TYPE_MAPPINGS[:guess]  ## alias for guess
TYPE_MAPPINGS[ :all ]    = TYPE_MAPPINGS[:guess]  ## alias for guess (yes, another one - why? why not?)





def self.convert_to_i( value )
  if value.nil? || value.empty?
    nil   ## return nil - why? why not?
  else
    Integer( value )
  end
end

def self.convert_to_f( value )
  if value.nil? || value.empty?
    nil   ## return nil - why? why not?
  else
    ## todo/fix: add support for NaN, Inf, -Inf etc.
    ##    how to deal with conversion errors (throw exception? ignore? NaN? why? why not?)
    Float( value )
  end
end

def self.convert_to_date( value )
  if value.nil? || value.empty?
    nil   ## return nil - why? why not?
  else
    ## todo/fix: add support for more formats
    ##    how to deal with conversion errors (throw exception? ignore? why? why not?)
    if value =~ /\d{4}-\d{1,2}-\d{1,2}/    ### todo: check if 2014-1-9 works for strptime too (leading zero rquired)?
      Date.strptime( value, "%Y-%m-%d" )    # 2014-11-09
    elsif value =~ /\d{1,2}\/\d{1,2}\/\d{4}/
      Date.strptime( value, "%d/%m/%Y" )    # 09/11/2014
    else
      ## todo/fix: throw argument/value error - why? why not
      nil
    end
  end
end



TYPE_CONVERTERS = {
  Integer => ->(value) { convert_to_i(value) },
  Float   => ->(value) { convert_to_f(value) },
  Date    => ->(value) { convert_to_date(value) },
}



end # class CsvHuman
