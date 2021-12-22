# CSV Humanitarian eXchange Language (HXL) Parser / Reader

csvhuman library / gem - read tabular data in the CSV Humanitarian eXchange Language (HXL)  format, that is, comma-separated values (CSV) line-by-line records with a hashtag (meta data) line using the Humanitarian eXchange Language (HXL) rules

* home  :: [github.com/csvreader/csvhuman](https://github.com/csvreader/csvhuman)
* bugs  :: [github.com/csvreader/csvhuman/issues](https://github.com/csvreader/csvhuman/issues)
* gem   :: [rubygems.org/gems/csvhuman](https://rubygems.org/gems/csvhuman)
* rdoc  :: [rubydoc.info/gems/csvhuman](http://rubydoc.info/gems/csvhuman)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)




## What's Humanitarian eXchange Language (HXL)?

[Humanitarian eXchange Language (HXL)](https://github.com/csvspecs/csv-hxl)
is a (meta data) convention for
adding agreed on hashtags e.g. `#org,#country,#sex+#targeted,#adm1`
inline in a (single new line / row)
between the last header row and the first data row
for sharing tabular data across organisations
(during a humanitarian crisis).
Example:


```
What,,,Who,Where,For whom,
Record,Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion
,#sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
001,WASH,Subsector 1,Org 1,Country 1,100,100,Region 1
002,Health,Subsector 2,Org 2,Country 2,,,Region 2
003,Education,Subsector 3,Org 3,Country 2,250,300,Region 3
004,WASH,Subsector 4,Org 1,Country 3,80,95,Region 4
```


## Usage

Pass in an array of arrays (or a stream responding to `#each` with an array of strings).
Example:


``` ruby
pp CsvHuman.parse( [["Organisation", "Cluster", "Province" ], ## or use HXL.parse
                    [ "#org", "#sector", "#adm1" ],
                    [ "Org A", "WASH", "Coastal Province" ],
                    [ "Org B", "Health", "Mountain Province" ],
                    [ "Org C", "Education", "Coastal Province" ],
                    [ "Org A", "WASH", "Plains Province" ]]
```

resulting in:

``` ruby
[{"org" => "Org A", "sector" => "WASH",      "adm1" => "Coastal Province"},
 {"org" => "Org B", "sector" => "Health",    "adm1" => "Mountain Province"},
 {"org" => "Org C", "sector" => "Education", "adm1" => "Coastal Province"},
 {"org" => "Org A", "sector" => "WASH",      "adm1" => "Plains Province"}]
```

Or pass in the text. Example:

``` ruby
pp CsvHuman.parse( <<TXT )      ## or use HXL.parse
  What,,,Who,Where,For whom,
  Record,Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion
  ,#sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
  001,WASH,Subsector 1,Org 1,Country 1,100,100,Region 1
  002,Health,Subsector 2,Org 2,Country 2,,,Region 2
  003,Education,Subsector 3,Org 3,Country 2,250,300,Region 3
  004,WASH,Subsector 4,Org 1,Country 3,80,95,Region 4
TXT
```

resulting in:

```
[{"sector+en"    => "WASH",
  "subsector"    => "Subsector 1",
  "org"          => "Org 1",
  "country"      => "Country 1",
  "sex+targeted" => [100, 100],
  "adm1"         => "Region 1"},
 {"sector+en"    => "Health",
  "subsector"    => "Subsector 2",
  "org"          => "Org 2",
  "country"      => "Country 2",
  "sex+targeted" => [nil, nil],
  "adm1"         => "Region 2"},
 {"sector+en"    => "Education",
  "subsector"    => "Subsector 3",
  "org"          => "Org 3",
  "country"      => "Country 2",
  "sex+targeted" => [250, 300],
  "adm1"         => "Region 3"},
 {"sector+en"    => "WASH",
  "subsector"    => "Subsector 4",
  "org"          => "Org 1",
  "country"      => "Country 3",
  "sex+targeted" => [80, 95],
  "adm1"         => "Region 4"}]
```


### What about Enumerable?

Yes, every reader includes `Enumerable` and runs on `each`.
Use `new` or `open` without a block
to get the enumerator (iterator).
Example:


``` ruby
csv = CsvHuman.new( <<TXT )      ## or use HXL.new
  What,,,Who,Where,For whom,
  Record,Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion
  ,#sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
  001,WASH,Subsector 1,Org 1,Country 1,100,100,Region 1
  002,Health,Subsector 2,Org 2,Country 2,,,Region 2
  003,Education,Subsector 3,Org 3,Country 2,250,300,Region 3
  004,WASH,Subsector 4,Org 1,Country 3,80,95,Region 4
TXT )
it  = csv.to_enum
pp it.next  
# => {"sector+en"    => "WASH",
#     "subsector"    => "Subsector 1",
#     "org"          => "Org 1",
#     "country"      => "Country 1",
#     "sex+targeted" => [100, 100],
#     "adm1"         => "Region 1"}


# -or-

csv = CsvHuman.open( "./test.csv" )     # or use HXL.open
it  = csv.to_enum
pp it.next
# => {"sector+en"    => "WASH",
#     "subsector"    => "Subsector 1",
#     "org"          => "Org 1",
#     "country"      => "Country 1",
#     "sex+targeted" => [100, 100],
#     "adm1"         => "Region 1"}
pp it.next
# => {"sector+en"    => "Health",
#     "subsector"    => "Subsector 2",
#     "org"          => "Org 2",
#     "country"      => "Country 2",
#     "sex+targeted" => [nil, nil],
#     "adm1"         => "Region 2"}
```



### More Ways to Use

``` ruby
csv = CsvHuman.new( recs )
csv.each do |rec|
  pp rec
end


CsvHuman.parse( recs ).each do |rec|
  pp rec
end


pp CsvHuman.read( "./test.csv" )

CsvHuman.foreach( "./test.csv" ) do |rec|
  pp rec
end

#...

```

or use the `HXL` alias:

``` ruby
hxl = HXL.new( recs )
hxl.each do |rec|
  pp rec
end


HXL.parse( recs ).each do |rec|
  pp rec
end


pp HXL.read( "./test.csv" )

HXL.foreach( "./test.csv" ) do |rec|
  pp rec
end

#...
```

Note: More aliases for `CsvHuman`, `HXL`? Yes, you can use
`CsvHum`, `CSV_HXL`, `CSVHXL` too.





### What about symbol keys for hashes?

Yes, you can use the `header_converter` keyword option.
Use `:symbol` for (auto-)converting header tags (strings) to symbols.
Note: the symbol converter will remove all hashtags (`#`) and spaces and
will change the plus (`+`) to underscore (`_`)
and remove all non-alphanumeric (e.g. `!?$%`) chars.

Example:

``` ruby
txt =<<TXT
What,,,Who,Where,For whom,
Record,Sector/Cluster,Subsector,Organisation,Country,Males,Females,Subregion
,#sector+en,#subsector,#org,#country,#sex+#targeted,#sex+#targeted,#adm1
001,WASH,Subsector 1,Org 1,Country 1,100,100,Region 1
002,Health,Subsector 2,Org 2,Country 2,,,Region 2
003,Education,Subsector 3,Org 3,Country 2,250,300,Region 3
004,WASH,Subsector 4,Org 1,Country 3,80,95,Region 4
TXT

pp CsvHuman.parse( txt, :header_converter => :symbol )      ## or use HXL.parse

# -or-

options = { :header_converter => :symbol }
pp CsvHuman.parse( txt, options )  
```

resulting in:

``` ruby
[{:sector_en    => "WASH",
  :subsector    => "Subsector 1",
  :org          => "Org 1",
  :country      => "Country 1",
  :sex_targeted => [100, 100],
  :adm1         => "Region 1"},
 # ...
 {:sector_en    => "WASH",
  :subsector    => "Subsector 4",
  :org          => "Org 1",
  :country      => "Country 3",
  :sex_targeted => [80, 95],
  :adm1         => "Region 4"}]
```

Built-in header converters include:

| Converter    | Comments            |
|--------------|---------------------|
| `:none`      |   string key; uses "normalized" tag e.g. `"#adm1 +code"`  |
| `:default`   |   string key; strips hashtags and spaces e.g. `"admin+code"`  |
| `:symbol`    |   symbol key; strips hashtags and spaces and converts plus (`+`) to underscore (`_`) and removes all non-alphanumerics e.g. `:admin_code` |

Or add your own converters. Example:

``` ruby
pp CsvHuman.parse( txt, header_converter: ->(h) { h.upcase } )
```

resulting in:

``` ruby
[{"#SECTOR +EN"    => "WASH",
  "#SUBSECTOR"     => "Subsector 1",
  "#ORG"           => "Org 1",
  "#COUNTRY"       => "Country 1",
  "#SEX +TARGETED" => [100, 100],
  "#ADM1"          => "Region 1"},
 # ...
]
```

A custom header converter is a method that gets the (normalized) header tag
passed in (e.g. `#sector +en`) as a string
and returns a string or symbol to use for the hash key in records.



### Tag Helpers

**Normalize**. Use `CsvHuman::Tag.normalize` to pretty print or normalize a tag.
All parts get downcased (lowercased), all attributes sorted by a-to-z,
all extra or missing hashtags or pluses added or removed,
all extra or missing spaces added or removed. Example:

``` ruby
HXL::Tag.normalize( "#sector+en" )
# => "#sector +en"
HXL::Tag.normalize( "#SECTOR EN" )
# => "#sector +en"
HXL::Tag.normalize( "# SECTOR  + #EN " )
# => "#sector +en"
HXL::Tag.normalize( "SECTOR EN" )
# => "#sector +en"
# ...
```


**Split**. Use `CsvHuman::Tag.split` to split (and normalize) a tag into its parts.
Example:

``` ruby
HXL::Tag.split( "#sector+en" )
# => ["sector", "en"]
HXL::Tag.split( "#SECTOR EN" )
# => ["sector", "en"]
HXL::Tag.split( "# SECTOR  + #EN " )
# => ["sector", "en"]
HXL::Tag.split( "SECTOR EN" )
# => ["sector", "en"]

## sort attributes a-to-z
HXL::Tag.split( "#affected +f +children" )
# => ["affected", "children", "f"]
HXL::Tag.split( "#population +children +affected +m" )
# => ["population", "affected", "children", "m"]
HXL::Tag.split( "#population+children+affected+m" )
# => ["population", "affected", "children", "m"]
HXL::Tag.split( "#population+#children+#affected+#m" )
# => ["population", "affected", "children", "m"]
HXL::Tag.split( "#population #children #affected #m" )
# => ["population", "affected", "children", "m"]
HXL::Tag.split( "POPULATION CHILDREN AFFECTED M" )
# => ["population", "affected", "children", "m"]
#...
```




## Frequently Asked Questions (FAQ) and Answers


###  Q: How to deal with un-tagged fields?

**A**: Un-tagged fields get skipped / ignored.


###  Q: How to deal with duplicate / repeated fields (e.g. `#sex+#targeted,#sex+#targeted`)?

**A**: Repeated fields (auto-magically) get turned into an array / list.




## License

The `csvhuman` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
