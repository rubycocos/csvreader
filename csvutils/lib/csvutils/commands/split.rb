# encoding: utf-8


class CsvTool

## command line tools
def self.split( args )

  config = { columns: [] }

  parser = OptionParser.new do |opts|
     opts.banner = "Usage: csvsplit [OPTS] datafile ..."

     opts.on("-c", "--columns=COLUMNS", "Name of header columns" ) do |columns|
       config[:columns] = columns.split(/[,|;]/)   ## allow differnt separators
     end

     opts.on("-h", "--help", "Prints this help") do
       puts opts
       exit
     end
  end

  parser.parse!( args )

  ## pp config
  ## pp args

  args.each do |arg|
    path = arg
    columns = config[:columns]

    puts "== #{File.basename(path)} (#{File.dirname(path)}) =="
    puts
    CsvUtils.split( path, *columns )
    puts
  end
end


end # class CsvTool
