# encoding: utf-8


class CsvTool

## command line tools
def self.header( args )

  config = {}

  parser = OptionParser.new do |opts|
     opts.banner = "Usage: csvheader [OPTS] datafile ..."

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

    puts "== #{File.basename(path)} (#{File.dirname(path)}) =="
    puts
    CsvUtils.pp_header( CsvUtils.header( path ) )
    puts
  end # each arg
end

end # class CsvTool
