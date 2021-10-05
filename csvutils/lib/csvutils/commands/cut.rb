# encoding: utf-8


class CsvTool

## command line tools
def self.cut( args )

  config = { columns: [] }

  parser = OptionParser.new do |opts|
     opts.banner = "Usage: csvcut [OPTS] source [dest]"

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

  source = args[0]
  dest   = args[1] || source   ## default to same as source (note: overwrites datafile in place!!!)

  unless args[0]
    puts "** error: arg missing - source filepath required - #{args.inspect}"
    exit 1
  end

  columns = config[:columns]

  CsvUtils.cut( source, *columns, output: dest )
end


end # class CsvTool
