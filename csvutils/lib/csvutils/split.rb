# encoding: utf-8




class CsvUtils

  def self.split( path, *columns, sep: ',', &blk )

    puts "cvssplit in: >#{path}<"

    ##  ["Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "HTHG", "HTAG"]
    puts "columns:"
    pp columns

    ## note: do NOT use headers
    ##   for easy sorting use "plain" array of array for records
    csv_options = { sep: sep }

    data = CsvReader.read( path, csv_options )

    ## todo/check: (auto-) strip (remove all leading and trailing spaces)
    ##     from all values - why? why not?
    ##   check if CSV.parse has an option for it?

    headers = data.shift   ## remove top array item (that is, row with headers)

    header_mapping = {}
    headers.each_with_index  { | header,i | header_mapping[header]=i }
    pp header_mapping

    ## map columns to array indices e.g. ['Season', 'Div'] => [1,2]
    column_indices = columns.map { |col| header_mapping[col] }
    pp column_indices


    ###################################################
    ## note: sort data by columns (before split)
    data = data.sort do |row1,row2|
       res = 0
       column_indices.each do |col|
         res = row1[col] <=> row2[col]    if res == 0
       end
       res
    end

    chunk = []
    data.each_with_index do |row,i|
      chunk << row

      next_row = data[i+1]

      changed = false
      if next_row.nil?   ## end-of-file
        changed = true
      else
        column_indices.each do |col|
          if row[col] != next_row[col]
             changed = true
             break   ## out of each column_indices loop
           end
        end
      end

      if changed
        puts "save new chunk:"
        column_values = column_indices.map {|col| row[col] }
        pp column_values

        # note: add header(s) row upfront (as first row) to chunk (with unshift)
        chunk_with_headers = chunk.unshift( headers )
        if blk
          yield( column_values, chunk_with_headers )
        else
          ## auto-save (write-to-file) by default - why? why not?
          split_write( path, column_values, chunk_with_headers, sep: sep )
        end

        chunk = []   ## reset chunk for next batch of records
      end
    end

    puts 'Done.'
  end  ## method self.split


  def self.split_write( inpath, values, chunk, sep: )
    basename = File.basename( inpath, '.*' )
    dirname  = File.dirname( inpath )

    ## check/change invalid filename chars
    ##  e.g. change 1990/91 to 1990-91
    extraname = values.map {|value| value.tr('/','-')}.join('~')

    outpath = "#{dirname}/#{basename}_#{extraname}.csv"
    puts "saving >#{basename}_#{extraname}.csv<..."

    File.open( outpath, 'w:utf-8' ) do |out|
      chunk.each do |row|
        out << csv_row( *row, sep: sep ).join( sep )
        out << "\n"
      end
    end
  end

end # class CsvUtils
