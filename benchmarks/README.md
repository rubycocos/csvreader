# CSV Reader (and Type Inference and Data Conversion) Benchmarks


_Fast, Faster, Fasterer, Fastest_


Simple benchmarks.
Use

    $ ruby ./benchmark.rb

to run.



**"Raw" Read Benchmark.**  Returns all strings - no type inference or data conversion [a].


```
n = 1000

                          user     system      total        real
std:                  9.203000   0.469000   9.672000 ( 10.237637)

split:                1.797000   0.312000   2.109000 (  2.147582)
split(tab):           1.843000   0.266000   2.109000 (  2.195966)
split(table)*:        4.172000   0.141000   4.313000 (  4.312704)
split(table):         4.141000   0.296000   4.437000 (  4.456251)

reader:             100.047000   0.375000 100.422000 (100.625725)
reader(tab):          1.969000   0.204000   2.173000 (  2.161369)
reader(table)*:       5.578000   0.171000   5.749000 (  5.755868)
reader(table):        5.609000   0.282000   5.891000 (  5.905285)
reader(json) [a]:     5.922000   0.328000   6.250000 (  6.252215)
reader(yaml) [a]:   120.250000  54.485000 174.735000 (174.893803)

hippie:              13.906000   0.484000  14.390000 ( 14.434999)
wtf:                 29.234000   0.250000  29.484000 ( 29.506184)
lenient [b]:          5.391000   0.266000   5.657000 (  5.648916)
```

Notes:

- [a] - YAML and JSON - of course - always use YAML and JSON encoding (and data conversion) rules :-).
- [b] - Lenient just "scans" for errors and warnings (that is, does NOT return or construct any records).




**Numerics Benchmark.**  Returns all numbers - simple type inference or data conversion [a] - it's all numbers - all the time (except for the header row).


```
n = 100
                           user     system      total        real
std:                 20.781000   0.234000  21.015000 ( 21.039186)

split:                1.531000   0.063000   1.594000 (  1.582496)
split(table):         2.000000   0.015000   2.015000 (  2.016913)

reader:              63.500000   0.203000  63.703000 ( 63.691851)
reader(table):       37.407000   0.188000  37.595000 ( 37.601160)
reader(numeric):     40.421000   0.141000  40.562000 ( 40.595467)
reader(json) [a]:     1.125000   0.062000   1.187000 (  1.191145)
reader(yaml) [a]:    38.485000  15.672000  54.157000 ( 54.229705)
```

Notes:

- [a] - YAML and JSON - of course - always use YAML and JSON encoding (and data conversion) rules :-).




## Updates

Thanks to [Victor Moroz](https://github.com/v66moroz):

``` ruby
x.report( 'xcsv:' )         { n.times do XCSV.open( "#{data_dir}/finance/MSFT.csv", &:to_a); end }
x.report( 'fastest-csv:' )  { n.times do FastestCSV.read( "#{data_dir}/finance/MSFT.csv" ); end }
```

resulting in:

```   
                          user     system      total        real
std:                  3.426003   0.031991   3.457994 (  3.458502)
split:                0.910320   0.008102   0.918422 (  0.918477)
xcsv [a]:             0.948309   0.020006   0.968315 (  0.968342)
fastest-csv [b]:      0.568832   0.020016   0.588848 (  0.588900)
```

Notes:

- [a] - [XCSV](https://github.com/v66moroz/xcsv) (gem: [xcsv](https://rubygems.org/gems/xcsv)) requires Rust and in the early stage of development, but can be easily extended.
- [b] - [FastestCSV](https://github.com/brightcode/fastest-csv) (gem: [fastest-csv](https://rubygems.org/gems/fastest-csv)) requires C, doesn't cover newlines (in quotes).



## Conclusion

And the winner is...


Of course - nothing is faster than "plain" `String#split` (with "simple csv", that is, no escape rules and edge cases):


``` ruby
def read_faster_csv( path, sep: ',' )
  recs = []
  File.open( path, 'r:utf-8' ) do |f|
     f.each_line do |line|
       line   = line.chomp( '' )
       values = line.split( sep )
       recs << values
     end
  end
  recs
end
```


Note: "Real World" CSV comes in many formats / flavors / dialects
and CSV fields can contain commas, quotes and newlines,
none of these escape rules and edge cases are covered by split.


