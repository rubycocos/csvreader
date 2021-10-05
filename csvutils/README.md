# csvutils - tools 'n' scripts for working with comma-separated values (csv) datafiles - the world's most popular tabular data interchange format in text


* home  :: [github.com/csvreader/csvutils](https://github.com/csvreader/csvutils)
* bugs  :: [github.com/csvreader/csvutils/issues](https://github.com/csvreader/csvutils/issues)
* gem   :: [rubygems.org/gems/csvutils](https://rubygems.org/gems/csvutils)
* rdoc  :: [rubydoc.info/gems/csvutils](http://rubydoc.info/gems/csvutils)
* forum :: [wwwmake](http://groups.google.com/group/wwwmake)



## Usage

### Command Line Tools

`csvhead`  •  `csvheader`  •  `csvstat`  •  `csvsplit`  •  `csvcut`


Try the help option `-h/--help` with the command line tools. Example:

```
$ csvhead -h          # or
$ csvhead --help
```

resulting in:

```
Usage: csvhead [OPTS] datafile ...
    -n, --num=NUM                    Number of rows
    -h, --help                       Prints this help
```

Now try it with `csvheader -h`, `csvstat -h`, `csvsplit -h`,
`csvcut -h` and so on.



#### Working with Comma-Separated Values (CSV) Datafile Examples

Let's use a sample datafile e.g. [`ENG.csv`](getting-started-samples/ENG.csv) from the
[football.csv project](https://github.com/footballcsv) with
matches from the English Premier League. Try


```
$ csvhead ENG.csv
```
to pretty print (pp) the first four rows (use the `-n/--num` option for more or less rows).
Resulting in:

```
== ENG.csv ==

<Date:11/08/17, Team1:Arsenal,        Team2:Leicester,    FT1:4, FT2:3>
<Date:12/08/17, Team1:Brighton,       Team2:Man City,     FT1:0, FT2:2>
<Date:12/08/17, Team1:Chelsea,        Team2:Burnley,      FT1:2, FT2:3>
<Date:12/08/17, Team1:Crystal Palace, Team2:Huddersfield, FT1:0, FT2:3>
 4 rows
```

Next try

```
$ csvheader ENG.csv
```

to print all header columns (the first row). Resulting in:

```
== ENG.csv ==

5 columns:
  1: Date
  2: Team1
  3: Team2
  4: FT1
  5: FT2
```

Next try:

```
$ csvstat -c Team1,Team2 ENG.csv
```

to show all unique values for the columns `Team1` and `Team2`.
Resulting in:

```
== ENG.csv ==

... 380 rows

5 columns:
  1: Date
  2: Team1
  3: Team2
  4: FT1
  5: FT2

column "Team1" - 20 unique values:
  19 x Arsenal
  19 x Bournemouth
  19 x Brighton
  19 x Burnley
  19 x Chelsea
  19 x Crystal Palace
  19 x Everton
  19 x Huddersfield
  19 x Leicester
  19 x Liverpool
  19 x Man City
  19 x Man United
  19 x Newcastle
  19 x Southampton
  19 x Stoke
  19 x Swansea
  19 x Tottenham
  19 x Watford
  19 x West Brom
  19 x West Ham
column "Team2" - 20 unique values:
  19 x Arsenal
  19 x Bournemouth
  19 x Brighton
  19 x Burnley
  19 x Chelsea
  19 x Crystal Palace
  19 x Everton
  19 x Huddersfield
  19 x Leicester
  19 x Liverpool
  19 x Man City
  19 x Man United
  19 x Newcastle
  19 x Southampton
  19 x Stoke
  19 x Swansea
  19 x Tottenham
  19 x Watford
  19 x West Brom
  19 x West Ham
```


#### Split & Cut - Split One Datafile into Many or Cut / Reorder Columns

Let's use another sample datafile e.g. [`AUT.csv`](getting-started-samples/AUT.csv) that holds many seasons
from the Austrian (AUT) Bundesliga. First lets see how many seasons:

```
$ csvstat -c Season AUT.csv
```

Resulting in:

```
== AUT.csv ==

... 360 rows

6 columns:
  1: Season
  2: Date
  3: Team1
  4: Team2
  5: FT1
  6: FT2

column "Season" - 2 unique values:
  180 x 2016/2017
  180 x 2017/2018
```

Now let's split the `AUT.csv` datafile by the `Season` column
resulting in two new datafiles named `AUT_2016-2017.csv`
and `ÀUT_2017-2018.csv`. Try:

```
$ csvsplit -c Season AUT.csv
```

Resulting in:

```
new chunk: ["2016/2017"] - saving "AUT_2016-2017.csv"...
new chunk: ["2017/2018"] - saving "AUT_2017-2018.csv"...
```

Let's cut out (remove) the `Season` column from the new `AUT_2016-2017.csv`
datafile. Try:

```
$ csvcut -c Date,Team1,Team2,FT1,FT2 AUT_2016-2017.csv
```

Double check the overwritten in-place cleaned-up datafile:

```
$ csvhead AUT_2016-2017.csv
```

resulting in:

```
== AUT_2016-2017.csv ==

<Date:23/07/16, Team1:Rapid Vienna, Team2:Ried,           FT1:5, FT2:0>
<Date:23/07/16, Team1:Altach,       Team2:AC Wolfsberger, FT1:1, FT2:0>
<Date:23/07/16, Team1:Sturm Graz,   Team2:Salzburg,       FT1:3, FT2:1>
<Date:24/07/16, Team1:St. Pölten,   Team2:Austria Vienna, FT1:1, FT2:2>
 4 rows
```

And so on and so forth.




### Code, Code, Code - Script Your Data Work Flow with Ruby

You can use all tools in your script using the `CsvUtils`
class methods:

| Shell       | Ruby                              |
|-------------|-----------------------------------|
| `csvhead`   |  [`CsvUtils.head( path, n: 4 )`](lib/csvutils/head.rb)    |
| `csvheader` |  [`CsvUtils.header( path )`](lib/csvutils/header.rb)        |
| `csvstat`   |  [`CsvUtils.stat( path, *columns )`](lib/csvutils/stat.rb)  |
| `csvsplit`  |  [`CsvUtils.split( path, *columns )`](lib/csvutils/split.rb) |
| `csvcut`    |  [`CsvUtils.cut( path, *columns, output: path)`](lib/csvutils/cut.rb)   |



Let's retry the sample above in a script:


``` ruby
require 'csvutils'


CsvUtils.head( 'ENG.csv' )
# same as:
#  $ csvhead ENG.csv

CsvUtils.header( 'ENG.csv' )
# same as:
#  $ csvheader ENG.csv

CsvUtils.stat( 'ENG.csv', 'Team1', 'Team2' )
# same as:
#  $ csvstat -c Team1,Team2 ENG.csv


CsvUtils.stat( 'AUT.csv', 'Season' )
# same as:
#  $ csvstat -c Season AUT.csv

CsvUtils.split( 'AUT.csv', 'Season' )
# same as:
#  $ csvsplit -c Season AUT.csv

CsvUtils.cut( 'AUT_2016-2017.csv', 'Date', 'Team1', 'Team2', 'FT1', 'FT2' )
# same as:
#  $ csvcut -c Date,Team1,Team2,FT1,FT2 AUT_2016-2017.csv
```



That's it. See the [`/getting-started-samples`](/getting-started-samples)
folder to
run the samples on your own computer.



## Install

Just install the gem:

```
$ gem install csvutils
```



## Alternatives

See the Libraries & Tools section in the [Awesome CSV](https://github.com/csvspecs/awesome-csv#libraries--tools) page.


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `csvutils` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
