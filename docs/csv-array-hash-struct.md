# Why the CSV standard library is broken, broken, broken (and how to fix it), Part III or Returning a CSV Record as an Array? Hash? Struct? Row?


What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.

Start with the (complete) series:
- **[Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser »](why-the-csv-stdlib-is-broken.md)**
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**



## What's a Comma-Separated Values (CSV) Record?

Let's read `data.csv`:

```
a,b,c
1,2,3
```

What do you expect?

``` ruby
pp CSV.read( 'data.csv' )
```

returns

``` ruby
[["a", "b", "c"],
 ["1", "2", "3"]]
```

That's great.  At it's most basic
a comma-separated values record once read in / parsed
is a list of values.


Now let's use a header. What do you expect now?

``` ruby
pp CSV.read( 'data.csv', headers: true )

# -or-

CSV.read( 'data.csv', headers: true ) do |record|
  pp record
end
```

Oh, no! Yes, that's where the trouble starts.

```
#<CSV::Table mode:col_or_row row_count:2>

-or-

#<CSV::Row "a":"1" "b":"2" "c":"3">
```

Adding `headers` to `CSV.read` turns the returned type into a lottery.
You may get a plain old array or a custom `CSV::Table` or a custom `CSV::Row`.
Let's fix it. How?

The new `Csv.read` always, always, always returns an array of arrays
for the comma-separated values records. Period.

What about headers?

The new `CsvHash.read` (note, the `Hash` in the name)
always, always, always returns an array of hashes
for the comma-separated values records. Period.
No custom `CSV::Table` or custom `CSV::Row`. Thank you!
Example:

``` ruby
pp CsvHash.read( 'data.csv' )

# => [{"a"=>"1", "b"=>"2", "c"=>"3"}]
```

Bonus: Why not return a (typed) struct instead of a (schema-less) hash?

Great you asked :-).
Let's welcome `CsvRecord`.
that let's you define (typed) structs for
your comma-separated values (csv) records.
Example:

``` ruby
Abc = CsvRecord.define do
  field :a   ## note: default type is :string
  field :b
  field :c
end

# or in "classic" style:

class Abc < CsvRecord::Base
  field :a
  field :b
  field :c
end
```

and use it like:

``` ruby
pp Abc.read( 'data.csv')

# or

Abc.read( 'data.csv' ).each do |rec|
  puts "#{rec.a} #{rec.b} #{rec.c}"
end
```


resulting in:

```
[#<Abc:0x302c760 @values=["a","b","c"]>]

-or-

a b c
```

Note: If you use `CsvRecord` you "auto(magically)-build" the (typed) struct
(on-the-fly) from the headers in the datafile. Example:

``` ruby
pp CsvRecord.read( 'data.csv' )
[#<Class:0x405c770 @values=["a","b","c"]>]
```




## Reader vs Parser - Front-End vs Back-End

What's broken (and wrong, wrong, wrong) with the CSV standard library?
The CSV library is an all-in-one hairball with a
a (simplistic) `String#split` kludge instead of a purpose built parser.
Nothing new, see Part I (or Part II) in the series :-).


Why not use different "low-level" parsers
for supporting different CSV formats / dialects?

Let's fix it. Yes, we can.
The new CSV library alternative uses a reader for its "front-end"
e.g. `Csv.parse`, `CsvHash.parse`, `CsvRecord.parse`, etc.
and many parsers for its "back-end"
e.g. `Csv::ParserStd.parse`,
`Csv::ParserStrict.parse`,
`Csv::ParserTab.parse`, etc.
The idea is that the new "core" CSV library
welcomes and
is built on purpose for supporting new parsers.
For example, why not add a faster parser with c-extensions (in "native" code)?
Anyone ? :-).



How to use a different parser?
Change `Csv.read`, that is, a convenience shortcut for
`Csv.default.read` to:


``` ruby
Csv.strict.read( 'data.csv' )   # will use the ParserStrict
# -or-
Csv.tab.read( 'data.tab')       # will use the ParserTab ("strict" tab-format)
# and so on
```


You can also use different pre-configured / pre-defined
dialects / formats. Example:

``` ruby
Csv.mysql.read( 'data.csv')
Csv.postgresql_text.read( 'data.csv' )
Csv.excel.read( 'data.csv' )
# and so on
```

Note: `Csv.mysql`, for example, is a convenience shortcut for:

``` ruby
parser = CsvReader::ParserStrict.new( sep: "\t",
                                      quote: false,
                                      escape: true,
                                      null: "\\N" )
mysql = CsvReader.new( parser )
mysql.read( 'data.csv' )
```



## CSV is the Future  - The World's #1 Data Format

Anyways, what's the point?
The point is data is the new gold.
And CSV is the #1 and the world's most popular data format :-).

The csv standard library might have been once
"state-of-the-art" ten years ago - now in 2020 it's unfortunately a
dead horse with many many flaws
that cannot handle the (rich) diversity / dialects of csv formats.


The joke (and heart of the matter) is that if you
want to parse comma-separated values (csv) lines it is more
complicated than using `line.split(",")` and you need a purpose-built
parser for the (edge) cases and (special) escape rules, and, thus,
you're advised to use a csv library.
That's how it all started.
What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.


## Request for Comments (RFC)

Please post your comments to the [ruby-talk mailing list](https://rubytalk.org) thread. Thanks!
