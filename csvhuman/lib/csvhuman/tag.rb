# encoding: utf-8

class CsvHuman



class Tag

  ##  1) plus (with optional hashtag and/or optional leading and trailing spaces)
  ##  2) hashtag (with optional leading and trailing spaces)
  ##  3) spaces only (not followed by plus) or
  ##   note: plus pattern must go first (otherwise "sector  + en" becomes ["sector", "", "en"])
  SEP_REGEX = /(?:  \s*\++
                        (?:\s*\#+)?
                    \s*  )
                   |
               (?:  \s*\#+\s*  )
                   |
               (?:  \s+)
              /x    ## check if \s includes space AND tab?



  def self.split( value )
    value = value.strip
    value = value.downcase
    while value.start_with?('#') do   ## allow one or more hashes
      value = value[1..-1]    ## remove leading #
      value = value.strip   ## strip (optional) leading spaces (again)
    end
    ## pp value
    parts = value.split( SEP_REGEX )

    ## sort attributes a-z
    if parts.size > 2
       [parts[0]] + parts[1..-1].sort
    else
      parts
    end
  end


  def self.normalize( value )   ## todo: rename to pretty or something or add alias
    parts = split( value )
    name       = parts[0]
    attributes = parts[1..-1]   ## note: might be nil

    buf = ''
    if name  ## note: name might be nil too e.g. value = "" or value = "   "
      buf << '#' + name
      if attributes && attributes.size > 0
        buf << ' +'
        buf << attributes.join(' +')
      end
    end
    buf
  end



  ## todo/check:  find a better name for optional types keyword/option - why? why not?
  def self.parse( value, types: nil )
    parts = split( value )

    name       = parts[0]
    attributes = parts[1..-1]   ## todo/fix: check if nil (make it empty array [] always) - why? why not?


    ## fix!!!!
    ##   move types up to parser itself (only one lookup for datafile)!!!

    ## guess / map type
    types = :default   if types.nil?

    if types.is_a?( Proc )    ## allow/support "custom" mapping procs
      guess_type = types
    else  ## assume symbol (for lookup pre-built/known mapping procs)
      guess_type = TYPE_MAPPINGS[ types ]
      if guess_type.nil?
        ## todo/check: issue warning only (and fallback to none/String) - why? why not?
        raise ArgumentError, "missing type mapping >#{types.inspect}< for tag >#{name}<"
      end
    end

    type       = guess_type.call( name, attributes )

    new( name, attributes, type )
  end




  attr_reader :name
  attr_reader :attributes   ## use attribs or something shorter - why? why not?
  attr_reader :type


  def initialize( name, attributes=nil, type=String )
    @name       = name
    ## sorted a-z - note: make sure attributes is [] NOT nil if empty - why? why not?
    @attributes = attributes || []
    ## todo/check attributes:
    ##  "extract" two-letter language codes e.g. en, etc. - why? why not?
    ##  "extract" type codes e.g. num, date - why? why not?

    ## type as
    ##  - class (defaults to String) or
    ##  - "custom" symbol (e.g. :geo, :geo_lat_lon,:geo_coords,:code,:id, etc.)
    @type       = type

    if @type == String    ## note: String gets passed through as-is 1:1 (no converter required)
      @conv = nil
    else
      @conv = TYPE_CONVERTERS[ @type ]

      if @conv.nil?
        ## todo/check: use a different exception - why? why not?
        ##  default to string (and warning only) - why? why not?
        raise ArgumentError, "missing type converter >#{type.inspect}< for tag >#{to_s}<"
      end
    end
  end


  ## todo/check: rename to/use convert or call - why? why not?
  def typecast( value )
    ## note: if conv is nil/null - pass value through as is (1:1); used for Strings (by default)
    @conv ?  @conv.call( value ) : value
  end


  def key
    ## convenience short cut for "standard/default" string key
    ##   cache/pre-built/memoize - why? why not?
    ##  builds:
    ##   population+affected+children+f

    buf = ''
    buf << @name
    if @attributes && @attributes.size > 0
      buf << '+'
      buf << @attributes.join('+')
    end
    buf
  end

  def to_s
    ## cache/pre-built/memoize - why? why not?
    ##
    ##  builds
    ##     #population +affected +children +f

    buf = ''
    buf << '#' + @name
    if @attributes && @attributes.size > 0
      buf << ' +'
      buf << @attributes.join(' +')
    end
    buf
  end

end # class Tag


end # class CsvHuman
