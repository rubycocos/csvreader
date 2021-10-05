# encoding: utf-8


class CsvUtils

  def self.header( path, sep: ',', debug: false )   ## use header or headers - or use both (with alias)?
    row = CsvReader.header( path, sep: sep )

    pp row   if debug
    ## e.g.:
    #  "Country,League,Season,Date,Time,Home,Away,HG,AG,Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA\n"

    row
  end  # method self.header

end  # class CsvUtils
