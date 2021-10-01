# encoding: utf-8

require 'pp'


require 'csv'
require 'csvreader'


require_relative 'split'

require 'hippie_csv'
require 'wtf_csv'
require 'lenient_csv'



def data_dir
  './datasets'
end



class LenientCSV
  def self.read( path )
    txt = File.open( path, 'r:bom|utf-8' ) { |f| f.read }
    csv = new( txt )
    csv.to_a
  end
end
