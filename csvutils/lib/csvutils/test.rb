# encoding: utf-8


class CsvUtils

  ## test or dry run to check if rows can get read/scanned
  def self.test( path, sep: ',' )
    i = 0
    csv_options = { sep: sep }

    CsvHash.foreach( path, csv_options ) do |rec|
      i += 1
      print '.' if i % 100 == 0
    end

    puts " #{i} rows"
  end

end  # class CsvUtils
