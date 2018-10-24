# csvreader - read tabular data in the comma-separated values (csv) format the right way (uses best practices out-of-the-box with zero-configuration)


* home  :: [github.com/csvreader/csvreader](https://github.com/csvreader/csvreader)
* bugs  :: [github.com/csvreader/csvreader/issues](https://github.com/csvreader/csvreader/issues)
* gem   :: [rubygems.org/gems/csvreader](https://rubygems.org/gems/csvreader)
* rdoc  :: [rubydoc.info/gems/csvreader](http://rubydoc.info/gems/csvreader)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)


## What's News?



**v1.1.2**: Added built-in support for single quotes (`'`) to default parser ("The Right Way").
Now you can use both, that is, single (`'...'`) or double quotes (`"..."`)
like in ruby (or javascript or html or ...) :-).


**v1.1.1**: Added built-in support for (optional) alternative comments (`%`) - used by
[ARFF (attribute-relation file format)](https://waikato.github.io/weka-wiki/arff/) -
and support for (optional) directives (`@`) in header (that is, before any records)
to default parser ("The Right Way").
Now you can use either `#` or `%` for comments, the first one "wins" - you CANNOT use both.
Now you can use either a front matter (`---`) block
or directives (e.g. `@attribute`, `@relation`, etc.)
for meta data, the first one "wins" - you CANNOT use both.


**v1.1.0**: Added new fixed width field (fwf) parser (see `ParserFixed`) for supporting fields with fixed width (and no separator)
e.g.`Csv.fixed.parse( txt, width: [8,-2,8,-3,32,-2,14] )`.


**v1.0.3**: Added built-in support for an (optional) front matter (`---`) meta data block
in header (that is, before any records)
to default parser ("The Right Way") - used by [CSVY (yaml front matter for csv file format)](http://csvy.org).
Use `Csv.parser.meta` to get the parsed meta data block hash (or `nil`) if none.





## Usage


``` ruby
txt = <<TXT
1,2,3
4,5,6
TXT

records = Csv.parse( txt )     ## or CsvReader.parse
pp records
# => [["1","2","3"],
#     ["4","5","6"]]

# -or-

records = Csv.read( "values.csv" )   ## or CsvReader.read
pp records
# => [["1","2","3"],
#     ["4","5","6"]]

# -or-

Csv.foreach( "values.csv" ) do |rec|    ## or CsvReader.foreach
  pp rec
end
# => ["1","2","3"]
# => ["4","5","6"]
```


### What about type inference and data converters?

Use the converters keyword option to (auto-)convert strings to nulls, booleans, integers, floats, dates, etc.
Example:

``` ruby
txt = <<TXT
1,2,3
true,false,null
TXT

records = Csv.parse( txt, :converters => :all )     ## or CsvReader.parse
pp records
# => [[1,2,3],
#     [true,false,nil]]
```


Built-in converters include:

| Converter    | Comments          |
|--------------|-------------------|
| `:integer`   |   convert matching strings to integer |
| `:float`     |   convert matching strings to float   |
| `:numeric`   |   shortcut for `[:integer, :float]`   |
| `:date`      |   convert matching strings to `Date` (year/month/day) |
| `:date_time` |   convert matching strings to `DateTime` |
| `:null`      |   convert matching strings to null (`nil`) |
| `:boolean`   |   convert matching strings to boolean (`true` or `false`) |
| `:all`       |   shortcut for `[:null, :boolean, :date_time, :numeric]` |


Or add your own converters. Example:

``` ruby
Csv.parse( 'Ruby, 2020-03-01, 100', converters: [->(v) { Time.parse(v) rescue v }] )
#=> [["Ruby", 2020-03-01 00:00:00 +0200, "100"]]
```

A custom converter is a method that gets the value passed in
and if successful returns a non-string type (e.g. integer, float, date, etc.)
or a string (for further processing with all other converters in the "pipeline" configuration).



### What about Enumerable?

Yes, every reader includes `Enumerable` and runs on `each`.
Use `new` or `open` without a block
to get the enumerator (iterator).
Example:


``` ruby
csv = Csv.new( "a,b,c" )
it  = csv.to_enum
pp it.next  
# => ["a","b","c"]

# -or-

csv = Csv.open( "values.csv" )
it  = csv.to_enum
pp it.next
# => ["1","2","3"]
pp it.next
# => ["4","5","6"]
```





### What about headers?

Use the `CsvHash`
if the first line is a header (or if missing pass in the headers
as an array) and you want your records as hashes instead of arrays of strings.
Example:

``` ruby
txt = <<TXT
A,B,C
1,2,3
4,5,6
TXT

records = CsvHash.parse( txt )      ## or CsvHashReader.parse
pp records

# -or-

txt2 = <<TXT
1,2,3
4,5,6
TXT

records = CsvHash.parse( txt2, headers: ["A","B","C"] )      ## or CsvHashReader.parse
pp records

# => [{"A": "1", "B": "2", "C": "3"},
#     {"A": "4", "B": "5", "C": "6"}]

# -or-

records = CsvHash.read( "hash.csv" )     ## or CsvHashReader.read
pp records
# => [{"A": "1", "B": "2", "C": "3"},
#     {"A": "4", "B": "5", "C": "6"}]

# -or-

CsvHash.foreach( "hash.csv" ) do |rec|    ## or CsvHashReader.foreach
  pp rec
end
# => {"A": "1", "B": "2", "C": "3"}
# => {"A": "4", "B": "5", "C": "6"}
```


### What about symbol keys for hashes?

Yes, you can use the header_converters keyword option.
Use `:symbol` for (auto-)converting header (strings) to symbols.
Note: the symbol converter will also downcase all letters and
remove all non-alphanumeric (e.g. `!?$%`) chars
and replace spaces with underscores.

Example:

``` ruby
txt = <<TXT
a,b,c
1,2,3
true,false,null
TXT

records = CsvHash.parse( txt, :converters => :all, :header_converters => :symbol )  
pp records
# => [{a: 1,    b: 2,     c: 3},
#     {a: true, b: false, c: nil}]

# -or-
options = { :converters        => :all,
            :header_converters => :symbol }

records = CsvHash.parse( txt, options )  
pp records
# => [{a: 1,    b: 2,     c: 3},
#     {a: true, b: false, c: nil}]
```

Built-in header converters include:

| Converter    | Comments            |
|--------------|---------------------|
| `:downcase`  |   downcase strings  |
| `:symbol`    |   convert strings to symbols (and downcase and remove non-alphanumerics) |



### What about (typed) structs?

See the [csvrecord library »](https://github.com/csvreader/csvrecord)

Example from the csvrecord docu:

Step 1: Define a (typed) struct for the comma-separated values (csv) records. Example:

```ruby
require 'csvrecord'

Beer = CsvRecord.define do
  field :brewery        ## note: default type is :string
  field :city
  field :name
  field :abv, Float     ## allows type specified as class (or use :float)
end
```

or in "classic" style:

```ruby
class Beer < CsvRecord::Base
  field :brewery
  field :city
  field :name
  field :abv, Float
end
```


Step 2: Read in the comma-separated values (csv) datafile. Example:

```ruby
beers = Beer.read( 'beer.csv' )

puts "#{beers.size} beers:"
pp beers
```

pretty prints (pp):

```
6 beers:
[#<Beer:0x302c760 @values=
   ["Andechser Klosterbrauerei", "Andechs", "Doppelbock Dunkel", 7.0]>,
 #<Beer:0x3026fe8 @values=
   ["Augustiner Br\u00E4u M\u00FCnchen", "M\u00FCnchen", "Edelstoff", 5.6]>,
 #<Beer:0x30257a0 @values=
   ["Bayerische Staatsbrauerei Weihenstephan", "Freising", "Hefe Weissbier", 5.4]>,
 ...
]
```

Or loop over the records. Example:

``` ruby
Beer.read( 'beer.csv' ).each do |rec|
  puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
end

# -or-

Beer.foreach( 'beer.csv' ) do |rec|
  puts "#{rec.name} (#{rec.abv}%) by #{rec.brewery}, #{rec.city}"
end
```


printing:

```
Doppelbock Dunkel (7.0%) by Andechser Klosterbrauerei, Andechs
Edelstoff (5.6%) by Augustiner Bräu München, München
Hefe Weissbier (5.4%) by Bayerische Staatsbrauerei Weihenstephan, Freising
Rauchbier Märzen (5.1%) by Brauerei Spezial, Bamberg
Münchner Dunkel (5.0%) by Hacker-Pschorr Bräu, München
Hofbräu Oktoberfestbier (6.3%) by Staatliches Hofbräuhaus München, München
```


### What about tabular data packages with pre-defined types / schemas?

See the [csvpack library »](https://github.com/csvreader/csvpack)





## Frequently Asked Questions (FAQ) and Answers

### Q: What's CSV the right way? What best practices can I use?  

Use best practices out-of-the-box with zero-configuration.
Do you know how to skip blank lines or how to add `#` single-line comments?
Or how to trim leading and trailing spaces?  No worries. It's turned on by default.

Yes, you can. Use

```
#######
# try with some comments
#   and blank lines even before header (first row)

Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%

Bayerische Staatsbrauerei Weihenstephan,  Freising,  Hefe Weissbier,   5.4%
Brauerei Spezial,                         Bamberg,   Rauchbier Märzen, 5.1%
Hacker-Pschorr Bräu,                      München,   Münchner Dunkel,  5.0%
Staatliches Hofbräuhaus München,          München,   Hofbräu Oktoberfestbier, 6.3%
```

instead of strict "classic"
(no blank lines, no comments, no leading and trailing spaces, etc.):

```
Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
```


Or use the ARFF (attribute-relation file format)-like alternative style
with `%` for comments and `@`-directives 
for "meta data" in the header (before any records):

```
%%%%%%%%%%%%%%%%%%
% try with some comments
%   and blank lines even before @-directives in header 

@RELATION Beer

@ATTRIBUTE Brewery
@ATTRIBUTE City
@ATTRIBUTE Name
@ATTRIBUTE Abv

@DATA
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%

Bayerische Staatsbrauerei Weihenstephan,  Freising,  Hefe Weissbier,   5.4%
Brauerei Spezial,                         Bamberg,   Rauchbier Märzen, 5.1%
Hacker-Pschorr Bräu,                      München,   Münchner Dunkel,  5.0%
Staatliches Hofbräuhaus München,          München,   Hofbräu Oktoberfestbier, 6.3%
```


### Q: How can I change the default format / dialect?

The reader includes more than half a dozen pre-configured formats,
dialects.

Use strict if you do NOT want to trim leading and trailing spaces
and if you do NOT want to skip blank lines. Example:

``` ruby
txt = <<TXT
1, 2,3
4,5 ,6

TXT

records = Csv.strict.parse( txt )
pp records
# => [["1","•2","3"],
#     ["4","5•","6"],
#     [""]]
```

More strict pre-configured variants include:

`Csv.mysql` uses:

``` ruby
ParserStrict.new( sep: "\t",
                  quote: false,
                  escape: true,
                  null: "\\N" )
```

`Csv.postgres` or `Csv.postgresql` uses:

``` ruby
ParserStrict.new( doublequote: false,
                  escape: true,
                  null: "" )
```

`Csv.postgres_text` or `Csv.postgresql_text` uses:

``` ruby
ParserStrict.new( sep: "\t",
                  quote: false,
                  escape: true,
                  null: "\\N" )
```

and so on.


### Q: How can I change the separator to semicolon (`;`) or pipe (`|`) or tab (`\t`)?

Pass in the `sep` keyword option
to the "strict" parser. Example:

``` ruby
Csv.strict.parse( ..., sep: ';' )
Csv.strict.read( ..., sep: ';' )
# ...
Csv.strict.parse( ..., sep: '|' )
Csv.strict.read( ..., sep: '|' )
# and so on
```

Note: If you use tab (`\t`) use the `TabReader`
(or for your convenience the built-in `Csv.tab` alias)!
Why? Tab =! CSV. Yes, tab is
its own (even) simpler format
(e.g. no escape rules, no newlines in values, etc.),
see [`TabReader` »](https://github.com/csvreader/tabreader).

``` ruby
Csv.tab.parse( ... )  # note: "classic" strict tab format
Csv.tab.read( ... )
# ...
```

If you want double quote escape rules, newlines in quotes values, etc. use
the "strict" parser with the separator (`sep`) changed to tab (`\t`).

``` ruby
Csv.strict.parse( ..., sep: "\t" )  # note: csv-like tab format with quotes
Csv.strict.read( ..., sep: "\t" )
# ...
```




### Q: How can I read records with fixed width fields (and no separator)?

Pass in the `width` keyword option with the field widths / lengths
to the "fixed" parser. Example:

``` ruby
txt = <<TXT
12345678123456781234567890123456789012345678901212345678901234
TXT

Csv.fixed.parse( txt, width: [8,8,32,14] )  # or Csv.fix or Csv.f
# => [["12345678","12345678", "12345678901234567890123456789012", "12345678901234"]]


txt = <<TXT
John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765
TXT

Csv.fixed.parse( txt, width: [8,8,32,14] )   # or Csv.fix or Csv.f
# => [["John",    "Smith",    "john@example.com",    "1-888-555-6666"],
#     ["Michele", "O'Reiley", "michele@example.com", "1-333-321-8765"]]

# and so on
```

<!--
Note: You can use for your convenience the built-in
`Csv.fix` or `Csv.f` aliases / shortcuts.
-->


Note: You can use negative widths (e.g. `-2`, `-3`, and so on)
to "skip" filler fields (e.g. `--`, `---`, and so on).
Example:

``` ruby
txt = <<TXT
12345678--12345678---12345678901234567890123456789012--12345678901234XXX
TXT

Csv.fixed.parse( txt, width: [8,-2,8,-3,32,-2,14] )  # or Csv.fix or Csv.f
# => [["12345678","12345678", "12345678901234567890123456789012", "12345678901234"]]
```


Bonus: If the width is a string (not an array)
(e.g. `'a8 a8 a32 Z*'` or `'A8 A8 A32 Z*'` and so on)
than the fixed width field parser
will use  `String#unpack` and the value of width as its format string spec.
Example:

``` ruby
txt = <<TXT
12345678123456781234567890123456789012345678901212345678901234
TXT

Csv.fixed.parse( txt, width: 'a8 a8 a32 Z*' )  # or Csv.fix or Csv.f
# => [["12345678","12345678", "12345678901234567890123456789012", "12345678901234"]]

txt = <<TXT
John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765
TXT

Csv.fixed.parse( txt, width: 'A8 A8 A32 Z*' )   # or Csv.fix or Csv.f
# => [["John",    "Smith",    "john@example.com",    "1-888-555-6666"],
#     ["Michele", "O'Reiley", "michele@example.com", "1-333-321-8765"]]

# and so on
```

| String Directive | Returns | Meaning                 |
|------------------|---------|-------------------------|
| `A`              | String  | Arbitrary binary string (remove trailing nulls and ASCII spaces) |
| `a`              | String  | Arbitrary binary string |
| `Z`              | String  | Null-terminated string  |


and many more. See the `String#unpack` documentation
for the complete format spec and directives.




### Q: What's broken in the standard library CSV reader?

Two major design bugs and many many minor.

(1) The CSV class uses [`line.split(',')`](https://github.com/ruby/csv/blob/master/lib/csv.rb#L1255) with some kludges (†) with the claim it's faster.
What?! The right way: CSV needs its own purpose-built parser. There's no other
way you can handle all the (edge) cases with double quotes and escaped doubled up
double quotes. Period.

For example, the CSV class cannot handle leading or trailing spaces
for double quoted values `1,•"2","3"•`.
Or handling double quotes inside values and so on and on.

(2) The CSV class returns `nil` for `,,` but an empty string (`""`)
for `"","",""`. The right way: All values are always strings. Period.

If you want to use `nil` you MUST configure a string (or strings)
such as `NA`, `n/a`, `\N`, or similar that map to `nil`.


(†): kludge - a workaround or quick-and-dirty solution that is clumsy, inelegant, inefficient, difficult to extend and hard to maintain

Appendix: Simple examples the standard csv library cannot read:

Quoted values with leading or trailing spaces e.g.

```
1, "2","3" , "4" ,5
```

=>

``` ruby
["1", "2", "3", "4" ,"5"]
```

"Auto-fix" unambiguous quotes in "unquoted" values e.g.

```
value with "quotes", another value
```

=>

``` ruby
["value with \"quotes\"", "another value"]
```

and some more.




## Alternatives

See the Libraries & Tools section in the [Awesome CSV](https://github.com/csvspecs/awesome-csv#libraries--tools) page.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvreader` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
