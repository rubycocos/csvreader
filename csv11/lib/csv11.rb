# encoding: utf-8


require 'pp'
require 'strscan'   ## StringScanner


# our own code
require 'csv11/version'   # note: let version always go first


module Values


  class Parser


    Token = Struct.new(:name, :value) do
      def unquoted?()      name=='UNQUOTED';      end
      def quoted?()        name=='QUOTED';        end
      def triple_quoted?() name=='TRIPLE_QUOTED'; end
    end

    class Unquoted < Token
      def initialize( value ) super( 'UNQUOTED', value ); end
    end

    class Quoted < Token
      def initialize( value ) super( 'QUOTED', value ); end
    end

    class TripleQuoted < Token
      def initialize( value ) super( 'TRIPLE_UNQUOTED', value ); end
    end



    def initialize
    end

##
##   how to handle:
##      country:dk
##      mailto:hello             ## use excluded (reserved names urn, mailto, http, https)
##      http://example.com
##      urn:hello:444
##      name:"hello, world!"


    def parse_line

      loop do
        t = parse_token
        if t.nil?
           puts "!! format error: expected token with value, returns nil - rest is >>#{@buffer.rest}<<"
           break
        end

        if @buffer.peek(1) == ','
           @buffer.getch   ## consume ','
           puts "adding value >>#{t.value}<<"
           @values << t.value
        elsif @buffer.eos?
           puts "adding (last) value >>#{t.value}<<"
           @values << t.value
           break
        elsif @buffer.peek(1) == ':'
           @buffer.getch  ## consume ':'

           ## todo/fix:
           ##    do NOT allow names for quoted, triple_quoted for now - why? why not?
           ##   issue a format error: why? why not??

           if @values.empty?
             ### note:special case:
             ##  if first token is a name/key
             ##   consume all the rest!! including commas, colons etc.
             ##    no escape needed for nothing
             value = @buffer.rest
             value = value.strip
             puts "adding (single-line) first named value >>#{t.value}<< : >>#{value}<<"
             @values << [t.value,value]
             break
           else
             t2 = parse_token( match_name: false )
             puts "adding named value >>#{t.value}<< : >>#{t2.value}<<"
             @values << [t.value,t2.value]

             if @buffer.peek(1) == ','
                @buffer.getch  ## consume ','
             elsif @buffer.eos?
                break
             else
                puts "!! format error: expected comma (,) or EOS - rest is >>#{@buffer.rest}<<"
                break
             end
           end
        else
          puts "!! format error: expected comma (,) or colon (:) or EOS - rest is >>#{@buffer.rest}<<"
          break
        end
      end
    end



    def match_triple_quoted?
      ## todo/fix: use @buffer.match - """ (next letter MUST Not be "!! e.g.""""" not valid!!!
      @buffer.peek(3) == %{"""} ||  ## double triple quotes
      @buffer.peek(3) == %{'''}     ## single triple quotes
    end

    ## todo/fix: use @buffer.match - " (next letter MUST Not be "!! e.g."" not valid!!!
    def match_quoted?
       @buffer.peek(1) == %{"} ||   ## double quote
       @buffer.peek(1) == %{'}      ## single quote
    end


    def parse_triple_quoted
       token = nil # nothing found

       if @buffer.peek(3) == %{"""}   ## double quote
         @buffer.getch  # consume double quote
         @buffer.getch
         @buffer.getch
         value = @buffer.scan_until( /(?=""")/)
         @buffer.getch  # consume double quote
         @buffer.getch
         @buffer.getch
         @buffer.skip( /[ \t]*/ )    ## skip trailing WHITESPACE
         puts %{quoted """...""" value >>#{value}<<}
         token = TripleQuoted.new( value )
       elsif @buffer.peek(3) == %{'''}   ## single quote
         @buffer.getch  # consume single quote
         @buffer.getch
         @buffer.getch
         value = @buffer.scan_until( /(?=''')/)
         @buffer.getch  # consume single quote
         @buffer.getch
         @buffer.getch
         @buffer.skip( /[ \t]*/ )    ## skip trailing WHITESPACE
         puts %{quoted '''...''' value >>#{value}<<}
         token = TripleQuoted.new( value )
       else
         ## do nothing; report format error
       end

       token
    end

    def parse_quoted
       token = nil # nothing found

       if @buffer.peek(1) == '"'   ## double quote
         @buffer.getch  # consume double quote
         value = @buffer.scan_until( /(?=")/)
         @buffer.getch  # consume double quote
         @buffer.skip( /[ \t]*/ )    ## skip trailing WHITESPACE
         puts %{quoted "..." value >>#{value}<<}
         token = Quoted.new( value )
       elsif @buffer.peek(1) == "'"   ## single quote
         @buffer.getch  # consume single quote
         value = @buffer.scan_until( /(?=')/)
         @buffer.getch  # consume single quote
         @buffer.skip( /[ \t]*/ )    ## skip trailing WHITESPACE
         puts %{quoted '...' value >>#{value}<<}
         token = Quoted.new( value )
       else
         ## do nothing; report format error
       end

       token
    end


    def parse_unquoted( match_name: true )
       ## unquoted value
       puts "collect unquoted token (match_name? => #{match_name})  - rest: >>#{@buffer.rest}<<"

       if match_name
         value = @buffer.scan_until( /(?=[,:]|$)/)

         ## check for reserverd "non-keys" e.g.:
         ###  https: http:
         ###  urn:
         ###  mailto:
         ###  file:
         ###    add some more??
         ##    todo/fix: add ip address e.g. 127.0.0.1: too ??
         reserved_names = %w{ https http urn mailto file }
         name_regex = %r{^[a-zA-Z0-9._-]+$}    ## todo/fix: allow more chars

         if @buffer.peek(1) == ':'
           if reserved_names.include?( value )
              ## continue scan until next comma or eos(end-of-string)!!!
              value << @buffer.scan_until( /(?=,|$)/)
           elsif name_regex.match( value ).nil?
              ## does NOT match name/key pattern
              ## continue scan until next comma or eos(end-of-string)!!!
              value << @buffer.scan_until( /(?=,|$)/)
           else
             ## continue
           end
         end
       else    ## do NOT match name (named values) e.g. do NOT include colon (:)
         value = @buffer.scan_until( /(?=[,]|$)/)
       end

       value = value.rstrip    ## right strip whitespace
       puts "value >>#{value}<<"
       token = Unquoted.new( value )
    end



    def parse_token( match_name: true )
       @buffer.skip( /[ \t]*/ )    ## skip WHITESPACE

       token = nil  # nothing found

       if match_triple_quoted?    # """...""" or '''...'''
         token = parse_triple_quoted
       elsif match_quoted?        # "..." or '...'
         token = parse_quoted
       else
         token = parse_unquoted( match_name: match_name )
       end
       token
    end



    def parse(str)
      puts ""
      puts "**** parse >>#{str}<<"

      @values = []
      @buffer = StringScanner.new(str)

      parse_line
      @values
    end
  end   ## class Parser



  def self.split( line )
    parser = Parser.new
    parser.parse( line )
  end

end # module Values


# say hello
puts Values.banner    if defined?( $RUBYLIBS_DEBUG )
