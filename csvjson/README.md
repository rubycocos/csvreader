# CSV <3 JSON Parser / Reader

csvjson library / gem - read tabular data in the CSV <3 JSON format, that is, comma-separated values CSV (line-by-line) records with javascript object notation (JSON) encoding rules

* home  :: [github.com/csvreader/csvjson](https://github.com/csvreader/csvjson)
* bugs  :: [github.com/csvreader/csvjson/issues](https://github.com/csvreader/csvjson/issues)
* gem   :: [rubygems.org/gems/csvjson](https://rubygems.org/gems/csvjson)
* rdoc  :: [rubydoc.info/gems/csvjson](http://rubydoc.info/gems/csvjson)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## What's CSV <3 JSON?

CSV <3 JSON is a Comma-Separated Values (CSV)
variant / format / dialect
where the line-by-line records follow the
JavaScript Object Notation (JSON) encoding rules.
It's a modern (simple) tabular data format that
includes arrays, numbers, booleans, nulls, nested structures, comments and more.
Example:


```
# "Vanilla" CSV <3 JSON

1,"John","12 Totem Rd. Aspen",true
2,"Bob",null,false
3,"Sue","Bigsby, 345 Carnival, WA 23009",false
```

or

```
# CSV <3 JSON with array values

1,"directions",["north","south","east","west"]
2,"colors",["red","green","blue"]
3,"drinks",["soda","water","tea","coffe"]
4,"spells",[]
```

For more see the [official CSV <3 JSON Format documentation »](https://github.com/csvspecs/csv-json)



## Usage

``` ruby
txt <<=TXT
# "Vanilla" CSV <3 JSON

1,"John","12 Totem Rd. Aspen",true
2,"Bob",null,false
3,"Sue","Bigsby, 345 Carnival, WA 23009",false
TXT

records = CsvJson.parse( txt )     ## or CSV_JSON.parse or CSVJSON.parse
pp records
# =>  [[1,"John","12 Totem Rd. Aspen",true],
#      [2,"Bob",nil,false],
#      [3,"Sue","Bigsby, 345 Carnival, WA 23009",false]]

# -or-

records = CsvJson.read( "values.json.csv" )   ## or CSV_JSON.read or CSVJSON.read
pp records
# =>  [[1,"John","12 Totem Rd. Aspen",true],
#      [2,"Bob",nil,false],
#      [3,"Sue","Bigsby, 345 Carnival, WA 23009",false]]

# -or-

CsvJson.foreach( "values.json.csv" ) do |rec|   ## or CSV_JSON.foreach or CSVJSON.foreach
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
csv = CsvJson.new( "1,2,3" )   ## or CSV_JSON.new or CSVJSON.new
it  = csv.to_enum
pp it.next  
# => [1,2,3]

# -or-

csv = CsvJson.open( "values.json.csv" )  ## or CSV_JSON.open or CSVJSON.open
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
"id","name","address","regular"
1,"John","12 Totem Rd. Aspen",true
2,"Bob",null,false
3,"Sue","Bigsby, 345 Carnival, WA 23009",false
TXT

records = CsvHash.json.parse( txt )
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

The `csvjson` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
