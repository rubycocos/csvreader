# encoding: utf-8


## note: for now use in-memory sqlite3 db

module CsvPack



class Meta   ## Pack(age) Meta / Manifest / Descriptor
  extend Forwardable

  def self.load_file( path )
    text = File.open( path, 'r:utf-8' ).read
    load( text )
  end
  ## todo: add alias method read

  def self.load( text )
    hash = JSON.parse( text )
    new( hash )
  end
  ## todo: add alias method parse


  def initialize( h )
    @h = h
  end

  def name()      @h['name']; end
  def title()     @h['title']; end
  def license()   @h['license']; end

  ## todo/fix: wrap resource in a class - why? why not?
  def resources() @h['resources']; end

  ##############
  def_delegators :@h, :[]    ## todo/fix: add some more hash delgates - why? why not?

  def pretty_print( printer )
    printer.text "Meta<#{object_id} @h.name=#{name}, ...>"
  end
end  # class Meta





class Pack
  ## load (tabular) datapackage into memory
  def initialize( path )

    ## convenience
    ## - check: if path is a folder/directory
    ##    (auto-)add  /datapackage.json

    @meta = Meta.load_file( path )

    pack_dir = File.dirname(path)

    pp @meta

    ## read in tables
    @tables = []
    @meta.resources.each do |r|
      ## build table data
      @tables << build_tab( r, pack_dir )
    end

    ## pp @tables
  end

  def meta() @meta; end  ## delegate known meta props (e.g. name, title, etc. - why? why not?)


  def tables()  @tables; end
  ## convenience method - return first table
  def table()   @tables[0]; end

  def build_tab( h, pack_dir )
    name          = h['name']
    relative_path = h['path']

    if relative_path.nil?
      relative_path = "#{name}.csv"
      puts "  warn: no path defined; using fallback '#{relative_path}'"
    end

    puts "  reading resource (table) #{name} (#{relative_path})..."
    pp h

    path = "#{pack_dir}/#{relative_path}"
    text = File.open( path, 'r:utf-8' ).read
    tab = Tab.new( h, text )
    tab
  end
end # class Pack


class Tab
  extend Forwardable

  def initialize( h, text )
    @h = h

    ## todo parse csv
    ##  note: use header options (first row MUST include headers)
    @data = CSV.parse( text, headers: true )

    pp @data[0]
  end

  def name()  @h['name']; end
  def_delegators :@data, :[], :each

  def pretty_print( printer )
    printer.text "Tab<#{object_id} @data.name=#{name}, @data.size=#{@data.size}>"
  end


  def up!
    # run Migration#up to create table
    connect!
    con = ActiveRecord::Base.connection

    con.create_table sanitize_name( name ) do |t|
      @h['schema']['fields'].each do |f|
        column_name = sanitize_name(f['name'])
        column_type = DATA_TYPES[f['type']]

        puts "  #{column_type} :#{column_name}  =>  #{f['type']} - #{f['name']}"

        t.send( column_type.to_sym, column_name.to_sym )   ## todo/check: to_sym needed?
      end
      t.string  :name
    end
  end

  def import!
    connect!
    con = ActiveRecord::Base.connection

    column_names = []
    column_types = []
    column_placeholders = []
    @h['schema']['fields'].each do |f|
      column_names << sanitize_name(f['name'])
      column_types << DATA_TYPES[f['type']]
      column_placeholders << '?'
    end

    sql_insert_into = "INSERT INTO #{sanitize_name(name)} (#{column_names.join(',')}) VALUES "
    puts sql_insert_into

    i=0
    @data.each do |row|
      i+=1
      ## next if i > 3   ## for testing; only insert a couple of recs

      ## todo: check if all string is ok; or number/date/etc. conversion needed/required?
      values = []
      row.fields.each_with_index do |value,index|   # get array of values
        type = column_types[index]
        ## todo add boolean ??
        if value.blank?
          values << 'NULL'
        elsif [:number,:float,:integer].include?( type )
          values << value           ## do NOT wrap in quotes (numeric)
        else
          esc_value = value.gsub( "'", "''" )  ## escape quotes e.g. ' becomse \'\', that is, double quotes
          values << "'#{esc_value}'"    ## wrap in quotes
        end
      end
      pp values

      sql = "#{sql_insert_into} (#{values.join(',')})"
      puts sql
      con.execute( sql )
    end
  end # method import!


  def import_v1!
     ### note: import via sql for (do NOT use ActiveRecord record class for now)
    con = ActiveRecord::Base.connection

    column_names = []
    column_types = []
    column_placeholders = []
    @h['schema']['fields'].each do |f|
      column_names << sanitize_name(f['name'])
      column_types << DATA_TYPES[f['type']]
      column_placeholders << '?'
    end

    sql = "INSERT INTO #{sanitize_name(name)} (#{column_names.join(',')}) VALUES (#{column_placeholders.join(',')})"
    puts sql

    i=0
    @data.each do |row|
      i+=1
      next if i > 3   ## for testing; only insert a couple of recs

      ## todo: check if all string is ok; or number/date/etc. conversion needed/required?
      params = row.fields   # get array of values
      pp params
      con.exec_insert( sql, 'SQL', params )  # todo/check: 2nd param name used for logging only??
    end
  end # method import!


  ### note:
  ## activerecord supports:
  ##  :string, :text, :integer, :float, :decimal, :datetime, :time, :date, :binary, :boolean

  ### mappings for data types
  ##  from tabular data package to ActiveRecord migrations
  ##
  #  see http://dataprotocols.org/json-table-schema/   (section Field Types and Formats)
  #
  # for now supports these types

  DATA_TYPES = {
    'string'   => :string,    ## use text for larger strings ???
    'number'   => :float,     ## note: use float for now
    'integer'  => :integer,
    'boolean'  => :boolean,
    'datetime' => :datetime,
    'date'     => :date,
    'time'     => :time,
    'year'     => :string,     ## note: map year for now to string - anything better? why? why not?
  }

  def dump_schema
    ## try to dump schema (fields)
    puts "*** dump schema:"

    @h['schema']['fields'].each do |f|
      puts "   #{f['name']} ( #{sanitize_name(f['name'])} ) : #{f['type']}} ( #{DATA_TYPES[f['type']]} )"
    end

  end


  def sanitize_name( ident )
    ##
    ## if identifier starts w/ number add leading underscore (_)
    ##  e.g. 52 Week Price  => becomes  _52_week_price

    ident = ident.strip.downcase
    ident = ident.gsub( /[\.\-\/]/, '_' )  ## convert some special chars to underscore (e.g. dash -)
    ident = ident.gsub( ' ', '_' )
    ident = ident.gsub( /[^a-z0-9_]/, '' )
    ident = "_#{ident}"  if ident =~ /^[0-9]/
    ident
  end


  def ar_clazz
    @ar_clazz ||= begin
      clazz = Class.new( ActiveRecord::Base ) do
        ## nothing here for now
      end
      puts "set table_name to #{sanitize_name( name )}"
      clazz.table_name = sanitize_name( name )
      clazz
    end
    @ar_clazz
  end

private

  ## helper to get connection; if not connection established use defaults
  def connect!
    ## todo: cache returned con - why, why not ??
    unless ActiveRecord::Base.connected?
      puts "note: no database connection established; using defaults (e.g. in-memory SQLite database)"
      ActiveRecord::Base.establish_connection( adapter:  'sqlite3', database: ':memory:' )
      ActiveRecord::Base.logger = Logger.new( STDOUT )
    end
    ActiveRecord::Base.connection
  end

end # class Tab

end # module CsvPack
