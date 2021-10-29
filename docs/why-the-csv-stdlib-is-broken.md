**Update:** What started with this article - is now an almost endless :-) ongoing article series. Read all episodes (and stay tuned for more :-)):

- **Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser** - You're here :-)  
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**
- **[Part III or Returning a CSV Record as an Array? Hash? Struct? Row? »](csv-array-hash-struct.md)**
- **[Part IV or Numerics a.k.a. Auto-Magic Type Inference for Strings and Numbers »](csv-numerics.md)**




#  Why the CSV standard library is broken, broken, broken (and how to fix it)

What's broken (and wrong, wrong, wrong)
with the CSV standard library? Let's count the ways.
Let's kick off with an example:

``` ruby
require 'csv'
require 'pp'

begin
  CSV.parse( %{1, "2"} )
rescue CSV::MalformedCSVError => ex
  pp ex
end
# => #<CSV::MalformedCSVError: Illegal quoting in line 1.>

begin
  CSV.parse( %{"3" , 4} )
rescue CSV::MalformedCSVError => ex
  pp ex
end
# => #<CSV::MalformedCSVError: Unclosed quoted field on line 1.>

pp CSV.parse( %{"","",,} )
# => ["", "", nil, nil]
```

Is that what you expected?



## Strict CSV Format "Out-of-the-Box" - No Batteries Included (No Leading and Trailing Whitespace, No Blanks, No Comments, ...)

Let's say you want to read in a CSV datafile
with comments and skipping blank lines
and stripping all leading and trailing whitespaces in values [^1]
and with the unicode utf8 character encoding:

Example - `beer11.csv`:

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

Let's start with the CSV configuration extravaganza.
We need two regular expressions (regex) -
one for skipping comments and one for skipping blank lines with spaces only:

``` ruby
COMMENTS_REGEX = /^\s*#/
BLANK_REGEX    = /^\s*$/   ## skip all whitespace lines - note: use "" for a blank record
SKIP_REGEX = Regexp.union( COMMENTS_REGEX, BLANK_REGEX )
```

Next we need a custom converter for stripping leading and trailing spaces
from values:

``` ruby
##  register our own converters
CSV::Converters[:strip] = ->(field) { field.strip }
```

and finally all-together lets setup the csv option hash:

``` ruby
csv_opts = {
  skip_lines:  SKIP_REGEX,
  skip_blanks: true,   ## note: skips lines with no whitespaces only e.g. line with space is NOT blank?!
  :converters => [:strip],
  encoding: 'utf-8'
}
```

Now try:

```
pp CSV.read( "beer11.csv", csv_opts )
```

Resulting in:

``` ruby
[["Brewery", "City", "Name", "Abv"],
 ["Andechser Klosterbrauerei", "Andechs", "Doppelbock Dunkel", "7%"],
 ["Augustiner Br\u00E4u M\u00FCnchen", "M\u00FCnchen", "Edelstoff", "5.6%"],
 ["Bayerische Staatsbrauerei Weihenstephan", "Freising", "Hefe Weissbier", "5.4%"],
 ["Brauerei Spezial", "Bamberg", "Rauchbier M\u00E4rzen", "5.1%"],
 ["Hacker-Pschorr Br\u00E4u", "M\u00FCnchen", "M\u00FCnchner Dunkel", "5.0%"],
 ["Staatliches Hofbr\u00E4uhaus M\u00FCnchen", "M\u00FCnchen", "Hofbr\u00E4u Oktoberfestbier", "6.3%"]]
```

Why not make the human format the default?
So everybody can use it out-of-the-box with zero-configuration? E.g.

``` ruby
pp CSV.read( "beer11.csv" )
```

How many people do you think care enough to configure the CSV standard library
before reading?

Note ^1: Stripping all leading and trailing whitespaces in values will NOT
work with quoted values - the CSV standard library has no purpose-built parser
that handles stripping of whitespaces, and, thus, the strip converter
will also strip "escaped" spaces inside quoted values e.g.:

```
  1," ","2 ",3   
```

resulting in

``` ruby
["1","","2","3"]
```

instead of the expected (preserved whitespace in quoted values):

```
["1"," ","2 ","3"]
```



## CSV Format - Strict Conventions vs Human Conventions

The CSV standard library was born as fastercsv. The claim was that the
new fastercsv library is faster than the old CSV standard library.
What's the (dirty) trick? The fastercsv library uses a
very, very, very strict CSV format so it can be faster by
using `line.split(",")` that runs on native c-code.

Let's try to read / parse:

```
1, "2","3" ,4
```

Example:

``` ruby
require 'csv'

CSV.parse( %{1, "2"} )
# => Illegal quoting in line 1. (CSV::MalformedCSVError).

CSV.parse( %{"3" ,4} )
# => Unclosed quoted field on line 1. (CSV::MalformedCSVError)
```

Just adding leading or trailing spaces to quoted values
leads to format errors / exceptions. And, sorry, the custom `:strip` converter
only gets called AFTER parsing, thus, it won't help or fix anything.

What to do? Sorry, there's no easy shortcut.
Yes, we need a (new) purpose built-parser for handling all the (edge) cases
in the CSV format. Using the "super-fast" `line.split(",")` kludge will NOT work.  



## New CSV Format Rule - (Unquoted) Empty Values Are `nil`

In the CSV format all values are by default strings. Remember: the CSV
format is a text format.
The CSV standard library makes up the "ingenious" new rule
that if you use empty quoted values (`"","",""`) you will get empty strings
(as expected) but if you use empty "unquoted" values (`,,`) - surprise, surprise -
you will get `nil`s. Example:

``` ruby
CSV.parse( %{"","",,} )
```

resulting in:

``` ruby
["", "", nil, nil]
```

instead of the expected (all string values):

``` ruby
["", "", "", ""]
```

The right way: All values are always strings. Period.

If you want to use `nil`s you MUST configure a string (or strings)
such as `NA`, `n/a`, `\N`, or similar that map to `nil`.




## Let' Welcome CsvReader :-) - The CSV Standard Library Alternative

Reads tabular data in the comma-separated values (csv) format the right way, that is, uses best practices out-of-the-box with zero-configuration.
Everything works as expected :-). Example:


``` ruby
require 'csvreader'

pp Csv.parse_line( %{1, "2"} )
# => ["1", "2"]

pp Csv.parse_line( %{"3" ,4} )
# => ["3","4"]

pp Csv.parse_line( %{"","",,} )
# => ["", "", "", ""]

pp Csv.read( "beer11.csv" )
# => [["Brewery", "City", "Name", "Abv"],
#     ["Andechser Klosterbrauerei", "Andechs", "Doppelbock Dunkel", "7%"],
#     ["Augustiner Br\u00E4u M\u00FCnchen", "M\u00FCnchen", "Edelstoff", "5.6%"],
#     ["Bayerische Staatsbrauerei Weihenstephan", "Freising", "Hefe Weissbier", "5.4%"],
#     ["Brauerei Spezial", "Bamberg", "Rauchbier M\u00E4rzen", "5.1%"],
#     ["Hacker-Pschorr Br\u00E4u", "M\u00FCnchen", "M\u00FCnchner Dunkel", "5.0%"],
#     ["Staatliches Hofbr\u00E4uhaus M\u00FCnchen", "M\u00FCnchen", "Hofbr\u00E4u Oktoberfestbier", "6.3%"]]
```



## Questions and Answers (Q & A)

> I disagree that it's broken. It's implementing the [strict] RFC [CSV format] 
> and gives you the tools that allow you to be less strict.   

No, it doesn't. The heart of the matter and the joke is that if you
want to parse comma-separated values (csv) lines it is more
complicated than using `line.split(",")` and you need a purpose-built
parser for the (edge) cases and (special) escape rules, and, thus,
you're advised to use a csv library.

After using the csv std library I'm getting all these parse errors
so I look at the source code and read-up what's going on and -
surprise, surprise - the joke is on me:

``` ruby
parts = parse.split(@col_sep_split_separator, -1)
```

(Source: [`csv/lib/csv.rb`](https://github.com/ruby/csv/blob/master/lib/csv.rb#L1248))

By definition it is impossible and unfixable unless you use your
own purpose built parser - sorry, there's no "ingenious" hack for a
supposed "faster" library and the excuse about parsing only very,
very, very strict RFC is getting old. What do all the other csv
libraries in the world do (see python, java, go, javascript, etc.)

Anyways, here's how a parser looks like (it's not magic but
definitely more work - e.g. instead of 10-20 lines you will have 100
or 200 or more):

```ruby
def parse_field( io, sep: ',' )
  value = ""
  skip_spaces( io ) ## strip leading spaces
  if (c=io.peek; c==sep || c==LF || c==CR || io.eof?) ## empty field
    ## return value; do nothing
  elsif io.peek == DOUBLE_QUOTE
    puts "start double_quote field - peek >#{io.peek}< (#{io.peek.ord})"
    io.getc ## eat-up double_quote
    loop do
       while (c=io.peek; !(c==DOUBLE_QUOTE || io.eof?))
         value << io.getc ## eat-up everything unit quote (")
       end
      break if io.eof?
      io.getc ## eat-up double_quote
      if io.peek == DOUBLE_QUOTE ## doubled up quote?
         value << io.getc ## add doube quote and continue!!!!
      else
      ....
```

(Source: [`csvreader/lib/csvreader/parser.rb`](https://github.com/csv11/csvreader/blob/master/lib/csvreader/parser.rb))

and so on and so forth. See the difference?



> Did you try reporting to upstream to see about fixing it?

Unfortunately, the csv library is an orphan abadoned by its original
author as a 1000 line single-file code bomb and would need some love
and care.

There are so many other major flaws e.g. why not just return a
hash if the csv file has a header. To conclude, the csv library might have been once
"state-of-the-art" ten years ago - now in 2020 it's unfortunately a
dead horse and cannot handle the (rich) diversity / dialects of csv
formats.



> Have you read the [strict] RFC 4180 [CSV format memo]? The quoting rules are in there.

Have you read it? :-) Let's start at the beginning (together):

**This memo provides information for the internet community. It does
not specify an internet standard of any kind.**

Or how about the classic "interoperability" rule printed on page 4:

**Implementors should "be
conservative in what you do, be liberal in what you accept from
others" (RFC 793) when processing CSV files.**

(Source: [ietf.org/rfc/rfc4180.txt](https://www.ietf.org/rfc/rfc4180.txt))
