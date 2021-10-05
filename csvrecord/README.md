# csvrecord - read in comma-separated values (csv) records with typed structs / schemas


* home  :: [github.com/csvreader/csvrecord](https://github.com/csvreader/csvrecord)
* bugs  :: [github.com/csvreader/csvrecord/issues](https://github.com/csvreader/csvrecord/issues)
* gem   :: [rubygems.org/gems/csvrecord](https://rubygems.org/gems/csvrecord)
* rdoc  :: [rubydoc.info/gems/csvrecord](http://rubydoc.info/gems/csvrecord)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## Usage

[`beer.csv`](test/data/beer.csv):

```
Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
```

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
beers = Beer.read( 'beer.csv' ).to_a

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


Or create new records from scratch. Example:

``` ruby
beer = Beer.new( 'Andechser Klosterbrauerei',
                 'Andechs',
                 'Doppelbock Dunkel',
                 '7%' )

# -or-

values = ['Andechser Klosterbrauerei', 'Andechs', 'Doppelbock Dunkel', '7%']
beer = Beer.new( values )

# -or-

beer = Beer.new( brewery: 'Andechser Klosterbrauerei',
                 city:    'Andechs',
                 name:    'Doppelbock Dunkel',
                 abv:     '7%' )

# -or-

hash = { brewery: 'Andechser Klosterbrauerei',
         city:    'Andechs',
         name:    'Doppelbock Dunkel',
         abv:     '7%' }
beer = Beer.new( hash )


# -or-

beer = Beer.new
beer.update( brewery: 'Andechser Klosterbrauerei',
             city:    'Andechs',
             name:    'Doppelbock Dunkel' )
beer.update( abv: 7.0 )

# -or-

beer = Beer.new
beer.parse( ['Andechser Klosterbrauerei', 'Andechs', 'Doppelbock Dunkel', '7%'] )

# -or-

beer = Beer.new
beer.parse( 'Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%' )

# -or-

beer = Beer.new
beer.brewery = 'Andechser Klosterbrauerei'
beer.name    = 'Doppelbock Dunkel'
beer.abv     = 7.0
```


And so on. That's it.


## Frequently Asked Questions (FAQs) and Answers

### Q: What about ActiveRecord models? Why not inherit from ActiveRecord::Base so you get the SQL relational database magic / machinery for "free"?

Good point. `CsvRecord` and `ActiveRecord` are different.
`ActiveRecord` has its own
database schema / attributes. Using [`CsvPack` - the tabular data
package](https://github.com/csvreader/csvpack) you can, however, for your convenience auto-generate
`ActiveRecord` model classes
and `ActiveRecord` schema migrations (that is, tables and indices, etc.)
from the tabular
datapackage schema (in the JSON Schema format).
That was kind of the start of the
exercise :-), that is, the genesis for building `CsvRecord`
in the first place.

To sum up - use `CsvRecord` for comma-separated values (csv) data
imports or data "wrangling"
and use `ActiveRecord` for SQL queries / analysis and more. In the
good old unix tradition - the work together but have its own (limited
/ focused) purpose.




## Alternatives

See the Libraries & Tools section in the [Awesome CSV](https://github.com/csvspecs/awesome-csv#libraries--tools) page.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvrecord` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
