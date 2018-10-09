# encoding: utf-8

class CsvReader



class Converter


# A Regexp used to find and convert some common Date formats.
  DATE_MATCHER     = / \A(?: (\w+,?\s+)?\w+\s+\d{1,2},?\s+\d{2,4}
                                  |
                            \d{4}-\d{2}-\d{2} )\z
                    /x

  # A Regexp used to find and convert some common DateTime formats.
  DATE_TIME_MATCHER = / \A(?: (\w+,?\s+)?\w+\s+\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2},?\s+\d{2,4}
                      |
            \d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}
                      |
            # ISO-8601
            \d{4}-\d{2}-\d{2}
              (?:T\d{2}:\d{2}(?::\d{2}(?:\.\d+)?(?:[+-]\d{2}(?::\d{2})|Z)?)?)?
        )\z
         /x


  CONVERTERS  = {
       ##
       ##  todo/fix: use regex INTEGER_MATCH / FLOAT_MATCH
       ##    to avoid rescue (with exception and stacktrace) for every try!!!
           integer: ->(value) {  Integer( value ) rescue value },
           float:   ->(value) {  Float( value ) rescue value },
           numeric:   [:integer, :float],
           date:     ->(value) {
             begin
               value.match?( DATE_MATCHER ) ? Date.parse( value ) : value
             rescue  #  date parse errors
               value
             end
           },
           date_time: ->(value) {
             begin
               value.match?( DATE_TIME_MATCHER ) ? DateTime.parse( value ) : value
             rescue  # encoding conversion or date parse errors
               value
             end
           },

           ## new - add null and boolean (any others): why? why not?
           null: -> (value) {
              ## turn empty strings into nil
              ##  rename to blank_to_nil or empty_to_nil or add both?
              ##  todo: add NIL, nil too? or #NA, N/A etc. - why? why not?
              if value.empty? || ['NULL', 'null', 'N/A', 'n/a', '#NA', '#na' ].include?( value )
                 nil
              else
                value
              end
           },
           boolean: -> (value) {
             ## check yaml for possible true/value values - any missing?
             ##  add more (or less) - why? why not?
             if ['TRUE', 'true', 't', 'ON', 'on', 'YES', 'yes'].include?( value )
               true
             elsif
               ['FALSE', 'false', 'f', 'OFF', 'off', 'NO', 'no'].include?( value )
               false
             else
               value
             end
           },
           bool: [:boolean],  ## bool convenience alias for boolean

           all:  [:null, :boolean, :date_time, :numeric],
         }


   HEADER_CONVERTERS = {
    downcase: ->(value) { value.downcase },
    symbol:   ->(value) { value.downcase.gsub( /[^\s\w]+/, "" ).strip.
                                          gsub( /\s+/, "_" ).to_sym
                        }
   }


def self.create_header_converters( converters )
  new( converters, HEADER_CONVERTERS )
end

def self.create_converters( converters )
  new( converters, CONVERTERS )
end



def initialize( converters, registry=CONVERTERS )
     converters = case converters
                  when nil then []
                  when Array then converters
                  else [converters]
                  end

     @converters = []

     converters.each do |converter|
        if converter.is_a? Proc  # custom code block
           add_converter( registry, &converter)
        else   # by name
           add_converter( converter, registry )
        end
     end
   end

   def to_a() @converters; end    ## todo: rename to/use converters attribute name - why? why not?
   def empty?() @converters.empty?; end

  def convert( value, index_or_header=nil )
    return value if value.nil?

    @converters.each do |converter|
        value = if converter.arity == 1  # straight converter
              converter.call( value )
            else
              ## note: for CsvReader pass in the zero-based field/column index (integer)
              ##       for CsvHashReader pass in the header/field/column name (string)
              converter.call( value, index_or_header )
            end
        break unless value.is_a?( String )  # note: short-circuit pipeline for speed
    end
    value  # final state of value, converted or original
  end


private

  def add_converter( name=nil, registry, &converter )
    if name.nil?  # custom converter
      @converters << converter
    else          # named converter
      combo = registry[name]
      case combo
      when Array  # combo converter
        combo.each do |converter_name|
          add_converter( converter_name, registry )
        end
      else   # individual named converter
        @converters << combo
      end
    end
  end # method add_converter

end  # class Converter

end # class CsvReader
