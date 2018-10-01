# csvreader - read tabular data in the comma-separated values (csv) format the right way (uses best practices out-of-the-box with zero-configuration)


* home  :: [github.com/csv11/csvreader](https://github.com/csv11/csvreader)
* bugs  :: [github.com/csv11/csvreader/issues](https://github.com/csv11/csvreader/issues)
* gem   :: [rubygems.org/gems/csvreader](https://rubygems.org/gems/csvreader)
* rdoc  :: [rubydoc.info/gems/csvreader](http://rubydoc.info/gems/csvreader)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## Usage


``` ruby
txt <<=TXT
1,2,3
4,5,6
TXT

records = CsvReader.parse( txt )     ## or Csv.parse
pp records
# => [["1","2","3"],
#     ["5","6","7"]]

# -or-

records = CsvReader.read( "values.csv" )   ## or Csv.read
pp records
# => [["1","2","3"],
#     ["5","6","7"]]

# -or-

CsvReader.foreach( "values.csv" ) do |rec|    ## or Csv.foreach
  pp rec
end
# => ["1","2","3"]
# => ["5","6","7"]
```


### What about headers?

Use the `CsvHashReader`
if the first line is a header (or if missing pass in the headers
as an array) and you want your records as hashes instead of arrays of strings.
Example:

``` ruby
txt <<=TXT
A,B,C
1,2,3
4,5,6
TXT

records = CsvHashReader.parse( txt )      ## or CsvHash.parse
pp records

# -or-

txt2 <<=TXT
1,2,3
4,5,6
TXT

records = CsvHashReader.parse( txt2, headers: ["A","B","C"] )      ## or CsvHash.parse
pp records

# => [{"A": "1", "B": "2", "C": "3"},
#     {"A": "4", "B": "5", "C": "6"}]

# -or-

records = CsvHashReader.read( "hash.csv" )     ## or CsvHash.read
pp records
# => [{"A": "1", "B": "2", "C": "3"},
#     {"A": "4", "B": "5", "C": "6"}]

# -or-

CsvHashReader.foreach( "hash.csv" ) do |rec|    ## or CsvHash.foreach
  pp rec
end
# => {"A": "1", "B": "2", "C": "3"}
# => {"A": "4", "B": "5", "C": "6"}
```



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



### Q: How can I change the separator to semicolon (`;`) or pipe (`|`)?

Pass in the `sep` keyword option. Example:

``` ruby
CsvReader.parse( ..., sep: ';' )
CsvReader.read( ..., sep: ';' )
# ...
CsvReader.parse( ..., sep: '|' )
CsvReader.read( ..., sep: '|' )
# ...
# and so on
```


Note: If you use tab (`\t`) use the `TabReader`! Why? Tab =! CSV. Yes, tab is
its own (even) simpler format
(e.g. no escape rules, no newlines in values, etc.),
see [`TabReader` »](https://github.com/datatxt/tabreader).



### Q: What's broken in the standard library CSV reader?

Two major design bugs and many many minor.

(1) The CSV class uses [`line.split(',')`](https://github.com/ruby/csv/blob/master/lib/csv.rb#L1248) with some kludges (†) with the claim it's faster.
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

See the Libraries & Tools section in the [Awesome CSV](https://github.com/csv11/awesome-csv#libraries--tools) page.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvreader` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
