# Why the CSV standard library is broken, broken, broken (and how to fix it), Part IV or Numerics a.k.a. Auto-Magic Type Inference for Strings and Numbers


What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.

Start with the (complete) series:
- **[Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser »](why-the-csv-stdlib-is-broken.md)**
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**
- **[Part III or Returning a CSV Record as an Array? Hash? Struct? Row? »](csv-array-hash-struct.md)**


## What about Numerics and Comma-Separated Values (CSV)?

Let's read `data.csv`:

```
1,2,3
"4","5","6"
```

What do you expect?

``` ruby
pp CSV.read( 'data.csv' )
```

returns

``` ruby
[["1", "2", "3"],
 ["4", "5", "6"]]
```

That's great.  At it's most basic
a comma-separated values record once read in / parsed
is always a list of string values. Period.


## What about Numbers?

You can use the converters keyword
option to (auto-)convert strings to nulls, booleans, dates,
and, yes, integers and floats.
Built-in converters include:

| Converter    | Comments          |
|--------------|-------------------|
| `:integer`   |   convert matching strings to integer |
| `:float`     |   convert matching strings to float   |
| `:numeric`   |   shortcut for `[:integer, :float]`   |

Example:

``` ruby
records = CSV.read( 'data.csv', :converters => :numeric )
pp records
# => [[1, 2, 3],
#     [4, 5, 6]]
```

That's great again.
Using type inference and data converters
turns a comma-separated values record into a list of numbers.


## Numbers and Strings Together - How? Possible?

Guess, what? There's a popular comma-separated values (CSV)
convention / variant / dialect:

Rule 1: Use "un-quoted" values for float numbers e.g. `1,2,3` or `1.0, 2.0, 3.0` etc.

Rule 2: Use quoted values for "non-numeric" strings e.g. `"4", "5", "6"` or `"Hello, World!"` etc.



Now - try to read this format with the standard CSV library in ruby.
Anyone? Sorry, it's impossible - why? how?

Oh no! Yes, - surprise, surprise - the
CSV standard library is broken, broken, broken again.
The built-in (or your own custom converters) only get the value (and the field position)
but NOT if the value was quoted or un-quoted.

Let's fix it. Use a purpose built-parser
that includes support for numerics (like the Python standard library
or panda's `read_csv` and many others).
What about ruby :-)?

Change

``` ruby
require 'csv'
```

to

``` ruby
require 'csvreader'
```

And now try:

``` ruby
records = Csv.numeric.read( 'data.csv' )   # or CsvReader.numeric.read
pp records
# => [[1.0, 2.0, 3.0],
#     ["4", "5", "6"]]
```

Voila! The new alternative csv reader library has built-in support
for the numerics
convention / variant / dialect.
Note: By convention all (auto-converted) numbers are floats. What else?



## What about Not A Number (NaN)?

The reader also lets you configure a list of values
that get auto-converted to `Float::NAN`, that is, Not A Number (NaN).
Example:

``` ruby
records = Csv.numeric.parse( '1,2,NAN,#NAN', nan: ['NAN', '#NAN'] )
pp records
# => [[1.0, 2.0, NaN, NaN]]
```

Note: The Not a Number (NaN) values are "un-quoted" values (like numbers)
in the comma-separated values (CSV) format.



What's the point? The standard library is broken and too simplistic.
A `string#split` kludge for "parsing" is a joke.
Only "real" purpose built parsers work for handling
all the edge case such as Not A Number (NaN) in
"un-quoted" values for the numerics dialect / variant / format.


> I disagree that it's broken. It's implementing the [strict] RFC [CSV format]
> and gives you the tools that allow you to be less strict.   

Anyone?  Show us how you handle the reading of the numerics variant
and Not a Number (NaN) with the standard csv library?


> Have you read the [strict] RFC 4180 [CSV format memo]? The quoting rules are in there.

What about numerics or Not a Number (NaN)?
The numerics rules are NOT in there, sorry.




## Innovate, Innovate, Innovate -  CSV <3 JSON

Believe it or not? CSV
the world's #1 and most popular data format
is alive and kicking.

What's next for CSV? CSV <3 JSON and much more.
Stay tuned for the next episode.


## Request for Comments (RFC)

Please post your comments to the [ruby-talk mailing list](https://rubytalk.org) thread. Thanks!

