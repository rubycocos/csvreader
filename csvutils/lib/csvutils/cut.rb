# encoding: utf-8

## check/use class or module ???


class CsvUtils

  def self.cut( path, *columns, output: path, sep: ',' )

    inpath  = path
    outpath = output   # note: output defaults to inpath (overwrites datafile in-place!!!)

    puts "cvscut in: >#{inpath}<  out: >#{outpath}<"

    ##  ["Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "HTHG", "HTAG"]
    puts "columns:"
    pp columns

    csv_options = { sep: sep }

    recs = CsvHash.read( inpath, csv_options )


    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( outpath ))  unless Dir.exists?( File.dirname( outpath ))


    ## note:
    ##  todo/fix: add two trailing spaces for pretty printing - why? why not?
    File.open( outpath, 'w:utf-8' ) do |out|
      out << csv_row( *columns, sep: sep ).join( sep )   ## for row add headers/columns
      out << "\n"
      recs.each do |rec|
        values = columns.map { |col| rec[col] }  ## find data for column
        out << csv_row( *values, sep: sep ).join( sep )
        out << "\n"
      end
    end

    puts 'Done.'
  end  ## method self.cut

end # class CsvUtils
