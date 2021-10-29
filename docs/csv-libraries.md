# Why the CSV standard library is broken (and how to fix it), Part VI or Fixes in Alternative CSV Libraries or Evolve or Die or Fast, Faster, Fasterer, Fastest

What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.

Start with the (complete) series:
- **[Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser »](why-the-csv-stdlib-is-broken.md)**
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**
- **[Part III or Returning a CSV Record as an Array? Hash? Struct? Row? »](csv-array-hash-struct.md)**
- **[Part IV or Numerics a.k.a. Auto-Magic Type Inference for Strings and Numbers »](csv-numerics.md)**
- **[Part V or Escaping the Stray Quote Error Hell - Do You Want Single, Double, or French Quotes With That Comma? »](csv-quotes.md)**



Heraclitus says, ["Panta rhei (πάντα ῥεῖ)"](https://en.wikipedia.org/wiki/Heraclitus#Panta_rhei.2C_.22everything_flows.22)
(engl. "Everything Changes")
or a more modern American "business" version is "Evolve or Die".

For the fossilized ye olde' CSV standard library
with the `String#split` kludge that comes down to  
if YOU (yes, why NOT YOU) do not fix the errors in the
code, than the library (or yes, even the language) will not die literally,
of course, but get replaced.

Let's look at the new (and old) kids on the block.
What CSV library alternatives are out there in
the wild and what are these upstarts trying to fix (or make better or different)?


## Fix #1: Tolerant, liberal, hippie flower power ("Live and let live") vs Conservative,  strict, draconian CSV RFC 4180 diktat ("One and only one")


The classic commentary from a true "there can only be one (simplistic) CSV format"
believer:

> Have you read the [strict CSV] RFC 4180 [two-page memo]? The quoting rules are in there.


Aside:  Find out more ["Why the CSV RFC 4180 "Strict" Memo Is Dangerous?"](https://github.com/csvspecs/awesome-csv#why-the-csv-rfc-4180-strict-memo-is-dangerous)
in the Awesome CSV page or just read on.


Or how about a quote right from the CSV standard library comments:

> CSV maintains a pretty strict definition of CSV taken directly from
> the RFC [4180]. [...] CSV will parse all valid CSV.
>
> (Source: [`ruby/csv.rb#L72`](https://github.com/ruby/csv/blob/master/lib/csv.rb#L72))

How will the CSV standard library parse all valid CSV?
The trick - of course - is: "valid" means just what
the library choose it to mean - neither more nor less.

Everytime someone adds a space
before a quote or uses a "stray" quote or mixed quotes -
the library and all its fanatics tell you - FIX YOUR DATA. INVALID CSV.
INVALID CSV. INVALID CSV. READ THE RFC4180.

How about fixing the ____ library, lazy ____?



### Alternative - Hippie CSV

github: [intercom/hippie_csv](https://github.com/intercom/hippie_csv) ★47, gem: [hippie_csv](https://rubygems.org/gems/hippie_csv)

Not making up the name. Let's cheer on Jessica O'Brien and friends.
The readme says:


Ruby's `CSV` is great. It complies with the [proposed CSV spec](https://www.ietf.org/rfc/rfc4180.txt)
pretty well. If you pass its methods bad or non-compliant CSVs, it'll rightfully
and loudly complain. It's great +1.

Except... if you want to be able to deal with files from the real world. At
[Intercom](https://intercom.io), we've seen lots of problematic CSVs from
customers importing data to our system. You may want to support such cases.
You may not always know the delimiter, nor the chosen quote character, in
advance.

HippieCSV is a ridiculously tolerant and liberal parser which aims to yield as
much usable data as possible out of such real-world CSVs.

[...]

Features

- Deduces the delimiter (supports `,`, `;`, and `\t`)
- Deduces the quote character (supports `'`, `"`, and `|`)
- Forgives backslash escaped quotes in quoted CSVs
- Forgives invalid newlines in quoted CSVs
- Heals many encoding issues (and aggressively forces UTF-8)
- Deals with many miscellaneous malformed types of CSVs
- Works when a [byte order mark](https://en.wikipedia.org/wiki/Byte_order_mark) is present



### Alternative - Lenient CSV

github: [sj26/lenientcsv](https://github.com/sj26/lenientcsv) ★2, gem: [lenientcsv](https://rubygems.org/gems/lenientcsv)

Let's cheer on Samuel Cochran and friends.
The readme says:

Ruby CSV parser supporting both RFC 4180 double double-quote and unix-style backslash escaping.



### Alternative - WTF CSV

github: [gremerritt/wtf_csv](https://github.com/gremerritt/wtf_csv) ★2, gem: [wtf_csv](https://rubygems.org/gems/wtf_csv)

Let's cheer on Greg Merritt and friends.
The readme says:

`wtf_csv` is a ruby gem to detect formatting issues in a CSV.

Motivation

The CSV file format is meant to be an easy way to transport data. Anyone who has had to maintain an import process, however, knows that it's easy to mess up. Usually the entire landscape looks like this:
  1. An importer expects CSV files to be provided in some specific format
  2. The files are given in a different format
  3. The import fails; or even worse, the import succeeds but the data is mangled
  4. Some poor soul must dig through the CSV file to figure out what happened. Usually issues are related to bad cell quoting, inconsistent column counts, etc.

This gem seeks to make this process less terrible by providing a way to easily surface common formatting issues in a CSV file.




## Fix #2: Use a "Plain Old" Hash and NOT `CSV::Table`, `CSV::Row`

### Alternative - Smarter CSV

github: [tilo/smarter_csv](https://github.com/tilo/smarter_csv) ★973, gem: [smarter_csv](https://rubygems.org/gems/smarter_csv)


Let's cheer on Tilo Sloboda and friends.
The readme says:

Ruby's CSV library's API is pretty old, and it's processing of CSV-files returning Arrays of Arrays feels 'very close to the metal'. The output is not easy to use - especially not if you want to create database records from it. Another shortcoming is that Ruby's CSV library does not have good support for huge CSV-files, e.g. there is no support for 'chunking' and/or parallel processing of the CSV-content (e.g. with Resque or Sidekiq),

As the existing CSV libraries didn't fit my needs, I was writing my own CSV processing - specifically for use in connection with Rails ORMs like Mongoid, MongoMapper or ActiveRecord. In those ORMs you can easily pass a hash with attribute/value pairs to the create() method. The lower-level Mongo driver and Moped also accept larger arrays of such hashes to create a larger amount of records quickly with just one call.



## Fix #3: Fast, Faster, Fasterer, Fastest

The CSV standard library was born as fastercsv.
The claim was that the new fastercsv library is faster than the old CSV standard library.
What's the (dirty) trick? The fastercsv library uses a very, very, very strict CSV format so it can be faster by using a `line.split(",")` kludge that runs on native c-code.

What's the "honest" way? Use a "proper" native c-extension, of course.


### Alternative - Fast CSV

github: [jpmckinney/fastcsv](https://github.com/jpmckinney/fastcsv) ★14, gem: [fastcsv](https://rubygems.org/gems/fastcsv)

Let's cheer on James McKinney and friends.
The readme says:


FastCSV implements its Ragel-based CSV parser in C at `FastCSV::Parser`.

FastCSV is a subclass of [CSV](http://ruby-doc.org/stdlib-2.1.1/libdoc/csv/rdoc/CSV.html). It overrides `#shift`, replacing the parsing code, in order to act as a drop-in replacement.

FastCSV's `raw_parse` requires a block to which it yields one row at a time. FastCSV uses [Fiber](http://www.ruby-doc.org/core-2.1.1/Fiber.html)s to pass control back to `#shift` while parsing.

CSV delegates IO methods to the IO object it's reading. IO methods that move the pointer within the file like `rewind` changes the behavior of CSV's `#shift`. However, FastCSV's C code won't take notice. We therefore null the Fiber whenever the pointer is moved, so that `#shift` uses a new Fiber.

CSV's `#shift` runs the regular expression in the `:skip_lines` option against a row's raw text. `FastCSV::Parser` implements a `row` method, which returns the most recently parsed row's raw text.

FastCSV is tested against the same tests as CSV. See [TESTS.md](https://github.com/jpmckinney/fastcsv/blob/master/TESTS.md) for details.


Why?

I evaluated [many CSV Ruby gems](https://github.com/jpmckinney/csv-benchmark#benchmark), and they were either too slow or had implementation errors. [rcsv](https://github.com/fiksu/rcsv) is fast and [libcsv](http://sourceforge.net/projects/libcsv/)-based, but it skips blank rows (Ruby's CSV module returns an empty array) and silently fails on input with an unclosed quote. [bamfcsv](https://github.com/jondistad/bamfcsv) is well implemented, but it's considerably slower on large files. I looked for Ragel-based CSV parsers to copy, but they either had implementation errors or could not handle large files. [commas](https://github.com/aklt/commas/blob/master/csv.rl) looks good, but it performs a memory check on each character, which is overkill.



### Alternative - Fastest CSV

github: [brightcode/fastest-csv](https://github.com/brightcode/fastest-csv) ★37, gem: [fastest-csv](https://rubygems.org/gems/fastest-csv)

Let's cheer on Maarten Oelering and friends.
The readme says:

Fastest CSV class for MRI Ruby and JRuby.
Faster than faster_csv and fasterer-csv.

Uses native C code to parse CSV lines in MRI Ruby and Java in JRuby.

Supports standard CSV according to RFC4180.
Not the so-called "csv" from Excel.

The interface is a subset of the CSV interface in Ruby 1.9.3.
The options parameter is not supported.




### Many More Alternatives

That's just a start - there are many more.
Any great alternative CSV libaries missing? Please, tell.




## Good News Ahead - Ruby Standard Gems, Gems, Gems - The Gemified Standard Library

> Did you try reporting to upstream to see about fixing it?

Unfortunately, the csv library is a dead horse. Why beat a dead horse?

Now the (fantastic) good news
to quote Jan Lelis:

Ruby's standard library is in the process of being gemified.
More and more libraries will be turned into RubyGems,
which can be updated independently from Ruby.

Learn more at Jan Lelis' [Ruby Standard Gems (`stdgems.org`)](https://stdgems.org)
website.




## Is Ruby Dead? Is Orange the New Red? Is Tab the New Space?

Believe it or not other languages
are getting more and more popular.
Python? JavaScript? R?

Let's have a look at the CSV libraries
in Python, JavaScript or Ye Good Olde' Perl
and compare with Ruby. Is Ruby dying? You decide.

Stay tuned for the next episode.



## Request for Comments (RFC)

Please post your comments to the [ruby-talk mailing list](https://rubytalk.org) thread. Thanks!
