# encoding: utf-8


class CsvUtils

  def self.pp_header( headers )  ## check: rename to print_headers or prettyprint_header - why? why not?
    puts "#{headers.size} columns:"
    headers.each_with_index do |header,i|
      puts "  #{i+1}: #{header}"
    end
  end


  ###################
  ## (simple) helper for "csv-encoding" values / row
  ##
  ##  todo: check for newline in value too? why? why not?
  def self.csv_row( *values, sep: ',' )
    values.map do |value|
       if value && (value.index( sep ) || value.index('"'))
         ## double quotes and enclose in double qoutes
         value = %Q{"#{value.gsub('"', '""')}"}
       else
         value
       end
    end
  end

end  # class CsvUtils
