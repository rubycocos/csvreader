# CSV <3 YAML Parser / Reader

csvyaml library / gem - read tabular data in the CSV <3 YAML format, that is, comma-separated values (CSV) line-by-line records with yaml ain't markup language (YAML) encoding rules

* home  :: [github.com/csvreader/csvyaml](https://github.com/csvreader/csvyaml)
* bugs  :: [github.com/csvreader/csvyaml/issues](https://github.com/csvreader/csvyaml/issues)
* gem   :: [rubygems.org/gems/csvyaml](https://rubygems.org/gems/csvyaml)
* rdoc  :: [rubydoc.info/gems/csvyaml](http://rubydoc.info/gems/csvyaml)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)


## What's CSV <3 YAML?

CSV <3 YAML is a Comma-Separated Values (CSV)
variant / format / dialect
where the line-by-line records follow the
YAML Ain't Markup Language (YAML) encoding rules.
It's a modern (simple) tabular data format that
includes arrays, numbers, booleans, nulls, nested structures, comments and more.
Example:


```
# "Vanilla" CSV <3 YAML

1,John,12 Totem Rd. Aspen,true
2,Bob,null,false
3,Sue,"Bigsby, 345 Carnival, WA 23009",false
```

or

```
# CSV <3 YAML with array values

1,directions,[north,south,east,west]
2,colors,[red,green,blue]
3,drinks,[soda,water,tea,coffe]
4,spells,[]
```

For more see the [official CSV <3 YAML Format documentation »](https://github.com/csvspecs/csv-yaml)



## Usage

``` ruby
txt <<=TXT
# "Vanilla" CSV <3 YAML

1,John,12 Totem Rd. Aspen,true
2,Bob,null,false
3,Sue,"Bigsby, 345 Carnival, WA 23009",false
TXT

records = CsvYaml.parse( txt )     ## or CSV_YAML.parse or CSVYAML.parse
pp records
# =>  [[1,"John","12 Totem Rd. Aspen",true],
#      [2,"Bob",nil,false],
#      [3,"Sue","Bigsby, 345 Carnival, WA 23009",false]]

# -or-

records = CsvYaml.read( "values.yaml.csv" )   ## or CSV_YAML.read or CSVYAML.read
pp records
# =>  [[1,"John","12 Totem Rd. Aspen",true],
#      [2,"Bob",nil,false],
#      [3,"Sue","Bigsby, 345 Carnival, WA 23009",false]]

# -or-

CsvYaml.foreach( "values.yaml.csv" ) do |rec|   ## or CSV_YAML.foreach or CSVYAML.foreach
  pp rec
end
# => [1,"John","12 Totem Rd. Aspen",true]
# => [2,"Bob",nil,false]
# => [3,"Sue","Bigsby, 345 Carnival, WA 23009",false]
```



### What about Enumerable?

Yes, the reader / parser includes `Enumerable` and runs on `each`.
Use `new` or `open` without a block
to get the enumerator (iterator).
Example:


``` ruby
csv = CsvYaml.new( "1,2,3" )   ## or CSV_YAML.new or CSVYAML.new
it  = csv.to_enum
pp it.next  
# => [1,2,3]

# -or-

csv = CsvYaml.open( "values.yaml.csv" )  ## or CSV_YAML.open or CSVYAML.open
it  = csv.to_enum
pp it.next
# => [1,"John","12 Totem Rd. Aspen",true]
pp it.next
# => [2,"Bob",nil,false]
```



### What about headers?

Yes, you can. Use the `CsvHash`
from the csvreader library / gem
if the first line is a header (or if missing pass in the headers
as an array) and you want your records as hashes instead of arrays of strings.
Example:

``` ruby
txt <<=TXT
id,name,address,regular
1,John,"12 Totem Rd., Aspen",true
2,Bob,null,false
3,Sue,"\"Bigsby\", 345 Carnival, WA 23009",false
TXT

records = CsvHash.yaml.parse( txt )
pp records

# => [{"id":      1,
#      "name":    "John",
#      "address": "12 Totem Rd. Aspen",
#      "regular": true},
#     {"id":      2,
#      "name":    "Bob",
#      "address": null,
#      "regular": false},
#    ... ]
```

For more see the [official CsvHash documentation in the csvreader library / gem »](https://github.com/csvreader/csvreader)



## License

The `csvyaml` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
