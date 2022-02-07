# encoding: utf-8


require 'pp'
require 'forwardable'

### csv
require 'csv'
require 'json'
require 'fileutils'


### downloader
require 'fetcher'

### activerecord w/ sqlite3
##  require 'active_support/all'    ## needed for String#binary? method
require 'active_record'



# our own code

require 'csvpack/version'      ## let version always go first
require 'csvpack/pack'
require 'csvpack/downloader'

module CsvPack

  def self.import( *args )
    ## step 1: download
    dl = Downloader.new
    args.each do |arg|
      dl.fetch( arg )
    end

    ## step 2: up 'n' import
    args.each do |arg|
      pack = Pack.new( "./pack/#{arg}/datapackage.json" )
      pack.tables.each do |table|
        table.up!
        table.import!
      end
    end
  end

end # module CsvPack



# say hello
puts CsvPack.banner    if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
