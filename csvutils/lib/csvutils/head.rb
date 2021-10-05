# encoding: utf-8


class CsvUtils

  ## test or dry run to check if rows can get read/scanned
  def self.head( path, sep: ',', n: 4 )
    i = 0
    csv_options = { sep: sep }

    CsvHash.foreach( path, csv_options ) do |rec|
      i += 1

      pp rec

      break if i >= n
    end

    puts " #{i} records"
  end

end  # class CsvUtils
