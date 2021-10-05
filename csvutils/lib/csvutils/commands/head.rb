# encoding: utf-8


class CsvTool

## command line tools
def self.head( args )

  config = { n: 4 }

  parser = OptionParser.new do |opts|
     opts.banner = "Usage: csvhead [OPTS] datafile ..."

     opts.on("-n", "--num=NUM", "Number of rows" ) do |num|
       config[:n] = num.to_i
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
    n = config[:n]

    puts "== #{File.basename(path)} (#{File.dirname(path)}) =="
    puts
    CsvUtils.head( path, n: n )
    puts
  end # each arg
end

end # class CsvTool
