# encoding: utf-8


class CsvUtils

  def self.stat( path, *columns, sep: ',', debug: false )

    csv_options = { sep: sep }

    values = {}
    nulls  = {}
    # check 1) nulls/nils (e.g. empty strings ""),
    #       2) not/appliation or available  n/a NA or NaN or ...
    #       3) missing - e.g. ?

    i=0
    CsvHash.foreach( path, csv_options ) do |rec|
      i += 1

      pp rec    if i == 1 && debug

      print '.' if i % 100 == 0

      ## collect unique values for passed in columns
      columns.each do |col|
        value = rec[col]    ## note: value might be nil!!!!!

        values[col] ||= Hash.new(0)
        values[col][ value ? value : '<nil>' ] +=1
      end

      ## alway track nulls - why? why not
      rec.each do |col,value|
        ## if value.nil?    ## todo/check - nil value possible (not always empty string - why? why not?)
        ##   puts "[debug] nil value in row:"
        ##   puts "#{col} = #{value.inspect} : #{value.class.name}"
        ## end

        if value.nil?
          nulls[col] ||= Hash.new(0)
          nulls[col]['nil'] +=1
        elsif value.empty?
          nulls[col] ||= Hash.new(0)
          nulls[col]['empty'] +=1
        elsif ['na', 'n/a', '-'].include?( value.downcase )
          nulls[col] ||= Hash.new(0)
          nulls[col]['na'] +=1
        elsif value == '?'    ## check for (?) e.g. value.include?( '(?)') - why? why not?
          nulls[col] ||= Hash.new(0)
          nulls[col]['?'] +=1
        else
          # do nothing; "regular" value
        end
      end
    end

    puts " #{i} rows"
    puts
    puts " nils/nulls :: empty strings :: na / n/a / undefined :: missing (?):"
    puts "   #{nulls.inspect}"
    puts

    ## dump headers first (first row with names of columns)
    headers = header( path, sep: sep, debug: debug )
    pp_header( headers )  ## pretty print header columns
    puts

    if values.any?
       ## pretty print (pp) / dump unique values for passed in columns
       values.each do |col,h|
         puts " column >#{col}< #{h.size} unique values:"
         ## sort by name/value for now (not frequency) - change - why? why not?
         sorted_values = h.to_a.sort {|l,r| l[0] <=> r[0] }
         sorted_values.each do |rec|
           puts "   #{rec[1]} x  #{rec[0]}"
         end
       end
    end
  end # method self.stat

end  # class CsvUtils
