# encoding: utf-8

class TabHashReader


def self.open( path, mode=nil, headers: nil, &block )   ## rename path to filename or name - why? why not?

    ## note: default mode (if nil/not passed in) to 'r:bom|utf-8'
    f = File.open( path, mode ? mode : 'r:bom|utf-8' )
    tab = new(f, headers: headers )

    # handle blocks like Ruby's open()
    if block_given?
      begin
        block.call( tab )
      ensure
        tab.close
      end
    else
      tab
    end
end # method self.open


def self.read( path, headers: nil )
    open( path, headers: headers ) { |tab| tab.read }
end



def self.foreach( path, headers: nil, &block )
  tab = open( path, headers: headers)

  if block_given?
    begin
      tab.each( &block )
    ensure
      tab.close
    end
  else
    tab.to_enum    ## note: caller (responsible) must close file!!!
    ## remove version without block given - why? why not?
    ## use Tab.open().to_enum  or Tab.open().each
    ##   or Tab.new( File.new() ).to_enum or Tab.new( File.new() ).each ???
  end
end # method self.foreach


def self.parse( data, headers: nil, &block )
  tab = new( data, headers: headers )

  if block_given?
    tab.each( &block )  ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  else  # slurp contents, if no block is given
    tab.read            ## note: caller (responsible) must close file!!! - add autoclose - why? why not?
  end
end # method self.parse




def initialize( data, headers: nil )
      raise ArgumentError.new( "Cannot parse nil as TAB" )  if data.nil?

      if data.is_a?( String )
        @input = data   # note: just needs each for each_line
      else  ## assume io
        @input = data
      end

      ## pass in headers as array e.g. ['A', 'B', 'C']
      @names = headers ? headers : nil
end



 include Enumerable


 def each( &block )

   ## todo/fix:
   ##   add case for headers/names.size != values.size
   ##   - add rest option? for if less headers than values (see python csv.DictReader - why? why not?)
   ##
   ##   handle case with duplicate and empty header names etc.


   if block_given?
     TabReader.parse( @input ) do |values|
        if @names.nil?    ## check for (first) headers row
          @names = values   ## store header row / a.k.a. field/column names
        else    ## "regular" record
          record = @names.zip( values ).to_h    ## todo/fix: check for more values than names/headers!!!
          block.call( record )
        end
     end
   else
     to_enum
   end
 end # method each

 def read() to_a; end # method read


 def close
   @input.close   if @input.respond_to?(:close)   ## note: string needs no close
 end


end # class TabHashReader
