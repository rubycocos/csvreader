# encoding: utf-8


require 'benchmark'



require_relative 'helper'


n = 100
# n = 10_000

Benchmark.bm(26) do |x|
  x.report( 'line (each_line):'           ) { n.times do readline_sample; end }
  x.report( 'line (each_line+chomp!):'    ) { n.times do readline_inplace_sample; end }
  x.report( 'line (each_line+scanner):'   ) { n.times do readline_scanner_sample; end }
  x.report( 'line (each_line+each_char):' ) { n.times do readchar_sample; end }

  x.report( 'line (parse+getch):'         ) { n.times do parse1_sample; end }
  x.report( 'line (parse+gets+slice):'    ) { n.times do parse2_sample; end }
  x.report( 'line (parse+gets+pos):'      ) { n.times do parse3_sample; end }
  x.report( 'line (parse+nobuf):'         ) { n.times do parse4_sample; end }
  x.report( 'line (parse+getch+num):'     ) { n.times do parse5_sample; end }

  x.report( 'line (parse+gets+scanner):'  ) { n.times do parse_scanner_sample; end }
  x.report( 'line (parse+gets+scanner*):' ) { n.times do parse_scanner_scanner_sample; end }
end


##                                   user     system      total        real
## line (each_line):            5.375000   6.141000  11.516000 ( 11.522474)
## line (each_line+chomp!):     4.375000   6.109000  10.484000 ( 10.496063)
## line (each_line+scanner):   13.984000   5.656000  19.640000 ( 19.644859)
## line (each_line+each_char): 43.188000   8.141000  51.329000 ( 51.325110)
## line (parse+getch):        116.921000   7.312000 124.233000 (124.293261)
## line (parse+gets+slice):   188.032000   8.500000 196.532000 (196.711467)
## line (parse+gets+pos):     141.375000  13.485000 154.860000 (154.922206)
## line (parse+nobuf):         63.718000   7.047000  70.765000 ( 70.774960)
## line (parse+getch+num):    127.750000   8.156000 135.906000 (136.168328)
## line (parse+gets+scanner): 127.875000   8.140000 136.015000 (136.358474)
## line (parse+gets+scanner*): 26.516000   7.375000  33.891000 ( 33.912854)
