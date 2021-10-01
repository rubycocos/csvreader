# encoding: utf-8


require 'pp'
require 'strscan'



require_relative 'read'

require_relative 'buffer'
require_relative 'buffer_line'
require_relative 'buffer_line_pos'
require_relative 'buffer_line_scanner'
require_relative 'buffer_num'

require_relative 'parser'
require_relative 'parser_nobuf'
require_relative 'parser_num'
require_relative 'parser_scanner'



def data_dir
  './datasets'
end



def readline_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     readline( f )
  end
end

def readline_inplace_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     readline_inplace( f )
  end
end

def readline_scanner_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     readline_scanner( f )
  end
end


def readchar_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     readchar( f )
  end
end


def parse1_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     Parser.parse( Buffer.new( f ) )
  end
end

def parse2_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     Parser.parse( BufferLine.new( f ) )
  end
end

def parse3_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     Parser.parse( BufferLinePos.new( f ) )
  end
end

def parse4_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     ParserNobuf.parse( f )
  end
end

def parse5_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     ParserNum.parse( BufferNum.new( f ) )
  end
end


def parse_scanner_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     Parser.parse( BufferLineScanner.new( f ) )
  end
end

def parse_scanner_scanner_sample
  File.open( "#{data_dir}/finance/MSFT.csv", 'r:utf-8' ) do |f|
     ParserScanner.parse( BufferLineScanner.new( f ) )
  end
end


## pp read_sample
## pp getch_sample
## pp getch2_sample
## pp getch3_sample
## pp parse4_sample
## pp parse_scanner_sample
## pp parse_scanner_scanner_sample
