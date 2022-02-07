# csvpack

tools 'n' scripts for working with tabular data packages using comma-separated values (CSV) datafiles in text with meta info (that is, schema, datatypes, ..) in datapackage.json; download, read into and query CSV datafiles with your SQL database (e.g. SQLite, PostgreSQL, ...) of choice and much more


* home  :: [github.com/csv11/csvpack](https://github.com/csv11/csvpack)
* bugs  :: [github.com/csv11/csvpack/issues](https://github.com/csv11/csvpack/issues)
* gem   :: [rubygems.org/gems/csvpack](https://rubygems.org/gems/csvpack)
* rdoc  :: [rubydoc.info/gems/csvpack](http://rubydoc.info/gems/csvpack)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## Usage


### What's a tabular data package?

> Tabular Data Package is a simple structure for publishing and sharing
> tabular data with the following key features:
>
> - Data is stored in CSV (comma separated values) files
> - Metadata about the dataset both general (e.g. title, author)
>   and the specific data files (e.g. schema) is stored in a single JSON file
>   named `datapackage.json` which follows the Data Package format

(Source: [Tabular Data Packages @ Frictionless Data Project • Data Hub.io • Open Knowledge Foundation • Data Protocols.org](https://datahub.io/docs/data-packages/tabular))



Here's a minimal example of a tabular data package holding two files, that is, `data.csv` and `datapackage.json`:

[`beer/data.csv`](test/pack/beer/data.csv):

```
Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
...
```

[`beer/datapackage.json`](test/pack/beer/datapackage.json):

``` json
{
  "name": "beer",
  "resources": [
    {
      "path": "data.csv",
      "schema": {
        "fields": [{ "name": "Brewery",   "type": "string" },
                   { "name": "City",      "type": "string" },
                   { "name": "Name",      "type": "string" },
                   { "name": "Abv",       "type": "number" }]
      }
    }
  ]
}
```



### Where to find data packages?

For some 100+ real world examples see the [Data Packages Listing](https://datahub.io/core) ([Sources](https://github.com/datasets), [Registry](https://github.com/datasets/registry/blob/master/core-list.csv))
at the Data Hub.io • Frictionless Data Project
website for a start. Tabular data packages include:


Name                     | Comments
------------------------ | -------------
`country-codes`          | Comprehensive country codes: ISO 3166, ITU, ISO 4217 currency codes and many more
`language-codes`         | ISO Language Codes (639-1 and 693-2)
`currency-codes`         | ISO 4217 Currency Codes
`gdb`                    | Country, Regional and World GDP (Gross Domestic Product)
`s-and-p-500-companies`  | S&P 500 Companies with Financial Information
`un-locode`              | UN-LOCODE Codelist
`bond-yields-uk-10y`     | 10 Year UK Government Bond Yields (Long-Term Interest Rate)
`gold-prices`            | Gold Prices (Monthly in USD)
`oil-prices`             | Brent crude and WTI oil prices from US EIA
`co2-emissions`          | Annual info about co2 emissions per nation
`co2-fossil-global`      | Global CO2 Emissions from fossil-fuels annually since 1751 till 2014




and many more


### Code, Code, Code - Script Your Data Workflow with Ruby


``` ruby
require 'csvpack'

CsvPack.import(
  's-and-p-500-companies',
  'gdb'
)
```

Using `CsvPack.import` will:

1) download all data packages to the `./pack` folder

2) (auto-)add all tables to an in-memory SQLite database using SQL `create_table`
   commands via `ActiveRecord` migrations e.g.


``` ruby
create_table :constituents do |t|
  t.string :symbol          # Symbol         (string)
  t.string :name            # Name           (string)
  t.string :sector          # Sector         (string)
end
```


3) (auto-)import all datasets using SQL inserts e.g.

``` sql
INSERT INTO constituents
  (symbol,
   name,
   sector)
VALUES  
  ('MMM',
   '3M Company',
   'Industrials')
```

4) (auto-)add ActiveRecord models for all tables.


So what? Now you can use all the "magic" of ActiveRecord to query
the datasets. Example:

``` ruby
pp Constituent.count

# SELECT COUNT(*) FROM "constituents"
# => 496


pp Constituent.first

# SELECT  "constituents".* FROM "constituents" ORDER BY "constituents"."id" ASC LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.find_by!( symbol: 'MMM' )

# SELECT  "constituents".*
#         FROM "constituents"
#         WHERE "constituents"."symbol" = "MMM"
#         LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.find_by!( name: '3M Company' )

# SELECT  "constituents".*
#          FROM "constituents"
#          WHERE "constituents"."name" = "3M Company"
#          LIMIT 1
# => #<Constituent:0x9f8cb78
#         id:     1,
#         symbol: "MMM",
#         name:   "3M Company",
#         sector: "Industrials">


pp Constituent.where( sector: 'Industrials' ).count

# SELECT COUNT(*) FROM "constituents"
#         WHERE "constituents"."sector" = "Industrials"
# => 63


pp Constituent.where( sector: 'Industrials' ).all

# SELECT "constituents".*
#         FROM "constituents"
#         WHERE "constituents"."sector" = "Industrials"
# => [#<Constituent:0x9f8cb78
#          id:     1,
#          symbol: "MMM",
#          name:   "3M Company",
#          sector: "Industrials">,
#      #<Constituent:0xa2a4180
#          id:     8,
#          symbol: "ADT",
#          name:   "ADT Corp (The)",
#          sector: "Industrials">,...]
```

and so on



### Frequently Asked Questions (F.A.Qs) and Answers


#### Q: How to dowload a data package ("by hand")?

Use the `CsvPack::Downloader` class to download a data package
to your disk (by default data packages get stored in `./pack`).

``` ruby
dl = CsvPack::Downloader.new
dl.fetch( 'language-codes' )
dl.fetch( 's-and-p-500-companies' )
dl.fetch( 'un-locode')
```

Will result in:

```
-- pack
   |-- language-codes
   |   |-- data
   |   |   |-- ietf-language-tags.csv
   |   |   |-- language-codes-3b2.csv
   |   |   |-- language-codes-full.csv
   |   |   `-- language-codes.csv
   |   `-- datapackage.json
   |-- s-and-p-500-companies
   |   |-- data
   |   |   `-- constituents.csv
   |   `-- datapackage.json
   `-- un-locode
       |-- data
       |   |-- code-list.csv
       |   |-- country-codes.csv
       |   |-- function-classifiers.csv
       |   |-- status-indicators.csv
       |   `-- subdivision-codes.csv
       `-- datapackage.json
```


#### Q: How to add and import a data package ("by hand")?

Use the `CsvPack::Pack` class to read-in a data package
and add and import into an SQL database.

``` ruby
pack = CsvPack::Pack.new( './pack/un-locode/datapackage.json' )
pack.tables.each do |table|
  table.up!      # (auto-) add table  using SQL create_table via ActiveRecord migration
  table.import!  # import all records using SQL inserts
end
```


#### Q: How to connect to a different SQL database?

You can connect to any database supported by ActiveRecord. If you do NOT
establish a connection in your script - the standard (default fallback)
is using an in-memory SQLite3 database.

##### SQLite

For example, to create an SQLite3 database on disk - lets say `mine.db` -
use in your script (before the `CsvPack.import` statement):

``` ruby
ActiveRecord::Base.establish_connection( adapter:  'sqlite3',
                                         database: './mine.db' )
```

##### PostgreSQL

For example, to connect to a PostgreSQL database use in your script
(before the `CsvPack.import` statement):

``` ruby
require 'pg'       ##  pull-in PostgreSQL (pg) machinery

ActiveRecord::Base.establish_connection( adapter:  'postgresql'
                                         username: 'ruby',
                                         password: 'topsecret',
                                         database: 'database' )
```




## Install

Just install the gem:

```
$ gem install csvpack
```



## Alternatives

See the [Tools and Plugins for working with Data Packages](https://frictionlessdata.io/software)
page at the Frictionless Data Project.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvpack` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.



## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
