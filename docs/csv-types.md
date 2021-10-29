# Why the CSV standard library is broken (and how to fix it), Part VII or What's Your Type? Guess. Again. And Again. And Again. Guess What's a Schema For?

What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.

Start with the (complete) series:
- **[Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser »](why-the-csv-stdlib-is-broken.md)**
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**
- **[Part III or Returning a CSV Record as an Array? Hash? Struct? Row? »](csv-array-hash-struct.md)**
- **[Part IV or Numerics a.k.a. Auto-Magic Type Inference for Strings and Numbers »](csv-numerics.md)**
- **[Part V or Escaping the Stray Quote Error Hell - Do You Want Single, Double, or French Quotes With That Comma? »](csv-quotes.md)**
- **[Part VI or Fixes in Alternative CSV Libraries or Evolve or Die or Fast, Faster, Fasterer, Fastest »](csv-libraries.md)**


The heart of the CSV standard library is the `String#split` kludge.

What else is dangerously simplistic and naive?

Let's have a look at the built-in type conversion.
Will it surprise you? Yes, it is broken, broken, broken. How? Why?


Let's read `data.csv`:

```
1,2,3
4.0,5.0,6.0
"7","8","9"
true,false,on,off,yes,no
nil,null,na,missing,?
```

What do you expect?

``` ruby
pp CSV.read( 'data.csv' )
```

returns

``` ruby
[["1", "2", "3"],
 ["4.0", "5.0", "6.0"],
 ["7", "8", "9"],
 ["true", "false", "on", "off", "yes", "no"],
 ["nil", "null", "na", "missing", "?"]]
```

That's great.  At it's most basic
a comma-separated values record once read in / parsed
is always a list of string values. Period.


Now let's read the `data.csv` with all built-in type inference data converters (`:converters => :all`) turned on.
What do you expect now?

``` ruby
pp CSV.read( 'data.csv', :converters => :all )
```

returns

``` ruby
[[1, 2, 3],
 [4.0, 5.0, 6.0],
 [7, 8, 9],
 ["true", "false", "on", "off", "yes", "no"],
 ["nil", "null", "na", "missing", "?"]]
```

Oh yes! Oh no!
Yes, the CSV standard library knows how to convert strings in line 1
to integers and strings in line 2 to floating point numbers.
The trouble starts in line 3.
What's the difference between `7` and `"7"`
or `8` and `"8"`? There's no difference - they are all integers. Is that right?

The case is more clear in line 4 and 5.
The CSV standard library has no built-in knowledge of (or converters for)
booleans (that is, `true` or `false`) or null (`nil`).

If you're looking on the bright side - you might say:
Missing converters are left as an exercise for the library user,
that is, YOU :-).
What's the deal? Come on.
How is the built-in type conversion broken, broken, broken. How? Why?

Let's look "under the hood" and see how the type inference "magic"
works in the CSV standard library:

``` ruby
# note: code "modernized" and edited for clarity

class CSV

# ...

Converters  = {
  integer:  ->(value) { Integer(value)) rescue value },
  float:    ->(value) { Float(value) rescue value },
  #  ...
}

# ...
def init_converters
  @converters = [
     Converters[:integer],
     Converters[:float],
     # ...
   ]
end

def convert(values)
   values.map do |value|
     @converters.each do |converter|
       break if value.nil?
       value = converter.call( value )
       break unless value.is_a?( String )  # short-circuit pipeline for speed
     end
     value  # final state of each value, converted or original
   end
 end
end # class CSV
```


Guess what?
The CSV standard library loops over every value
in every record with all the converters in the pipeline!
Let's say you have a string value "Hello".

- `Integer( "Hello" )` crashes with an exception and gets rescued.
- `Float("Hello")` crashes with an exception and gets rescued.
- ...
- Oh, I guess if it's still a string it's a string.

Now imagine a datafile with a hundred thousands records
and seventy fields. How many crashes
with exceptions and backtraces do you get for free "under the hood"?

Charles Oliver Natter (of JRuby Fame) writes:

Generating a 1000-deep stack trace on the JVM can cost in the neighborhood of a few milliseconds.
This doesn't sound like a lot until you start raising thousands of exceptions every second.
Ruby's CSV library can automatically convert values to Ruby types as they are read. It does this by cascading attempts from one converter to the next using trivial rescues to capture any errors. Each converter executes in turn until one of them is able to convert the incoming data successfully.

Unfortunately, before 9.0.3.0, this had a tremendous impact on performance. Every exception raised here had to generate a very expensive stack trace…ultimately causing CSV value conversions to spend all their time in the guts of the JVM processing stack trace frames.

(Source: [Performance Improvements in JRuby](http://blog.jruby.org/2015/10/performance_improvements_in_jruby_9030/))



So how can we fix it?
Of course if you're looking on the bright side - you might say:
Always adding converters with an field index
are left as an exercise for the library user,
that is, YOU :-). Did anyone tell you so?


So "the right way" is (simply)
adding a new option - lets call it `types` that lets you
specify the converter per field.
No more guessing and rescue loops.

Let's follow up on the last part
"Part VI or Fixes in Alternative CSV Libraries or Evolve or Die or Fast, Faster, Fasterer, Fastest"
and look at the new (and old) kids on the block.
What CSV library alternatives are out there in the wild and what are these upstarts trying to fix (or make better or different)?




## Fix #4: Type Converters per Field / Record Schemas

### Alternative - Fight CSV!

github: [railslove/fight_csv](https://github.com/railslove/fight_csv) ★38, gem: [fight_csv](https://rubygems.org/gems/fight_csv)

Let's cheer on Manuel Korfmann and friends.
The readme says:

It's 2011, and parsing CSV with Ruby still sucks? Enter FightCSV! It
will take the cumbersome out of your CSV parsing, while keeping the
awesome! Want some taste of that juicy fresh? Check out this example:

Consider you have a csv file called log_entries.csv which looks like
this:

```
Date,Person,Client/Project,Minutes,Tags,Billable
2011-08-15,John Doe,handsomelabs,60,blogpost,no
2011-08-15,Max Powers,beerbrewing,60,meeting,yes
2011-08-15,Tyler Durden,babysitting,180,"concepting, research",yes
2011-08-15,Hulk Hero,gardening,60,"meeting, research",no
2011-08-15,John Doe,handsomelabs,60,coding,yes
2011-08-08,John Doe,handsomelabs,60,"blabla, meeting",yes
```

**Schema**

Now you can define a class representing a row of the file. You only need
to include `FightCSV::Record`.

```ruby
class LogEntry
  include FightCSV::Record
end
```

But of course you want the values from each row to behave like proper
Ruby objects. This can be easily achieved by defining a schema in the
`LogEntry` class:

```ruby
class LogEntry
  include FightCSV::Record
  schema do
    field "Name"
    field "Client/Project", {
      identifier: :project
    }
  end
end
```

Now the LogEntry objects will have a `name` method corresponding to
the column called "Name" and a `project` method corresponding to the
column called "Client/Project".

But sometimes you don't only want to adjust the field names, but also
the values. In this case FightCSV offers converters. The "Billable"
column seems to represent boolean values, so let's tackle that:

```ruby
class LogEntry
  include FightCSV::Record
  schema do
    field "Name"
    field "Client/Project", {
      identifier: :project
    }

    field "Billable", {
      converter: ->(string) { string == "yes" ? true : false }
    }
  end
end

```

Often when converting something, we assume that it has a certain format.
The "Date" column for example should always be of the format
`/\d{2}\.\d{2}\.\d{4}/`. A validation can easily be added to a column
with FightCSV:

```ruby
class LogEntry
  include FightCSV::Record
  schema do
    field "Name"
    field "Client/Project", {
      identifier: :project
    }

    field "Billable", {
      converter: ->(string) { string == "yes" ? true : false }
    }

    field "Date", {
      validate: /\d{2}\.\d{2}\.\d{4}/,
      converter: ->(string) { Date.parse(string) }
    }
  end
end
```

The complete schema:

```ruby
class LogEntry
  include FightCSV::Record
  schema do
    field "Name"
    field "Client/Project", {
      identifier: :project
    }

    field "Billable", {
      converter: ->(string) { string == "yes" ? true : false }
    }

    field "Date", {
      validate: /\d{2}\.\d{2}\.\d{4}/,
      converter: ->(string) { Date.parse(string) }
    }

    field "Tags", {
      converter: ->(string) { string.split(",") }
    }

    field "Minutes", {
      validate: /\d+/,
      converter: ->(string) { string.to_i }
    }
  end
end
```



### Alternative - Honey Format CSV

github: [buren/honey_format](https://github.com/buren/honey_format) ★2, gem: [honey_format](https://rubygems.org/gems/honey_format)

Let's cheer on Jacob Burenstam and friends.
The readme says:


> Makes working with CSVs as smooth as honey.

Proper objects for CSV headers and rows, convert column values, filter columns and rows, small(-ish) performance overhead.

**Features**

- Proper objects for CSV header and rows
- Convert row and header column values
- Pass your own custom row builder
- Filter what columns and rows are included in CSV output
- Gracefully handle missing and duplicated header columns
- CLI - Simple command line interface
- Only ~5-10% overhead from using Ruby CSV, see benchmarks
- Has no dependencies other than Ruby stdlib
- Supports Ruby >= 2.3


**Quick use**

```ruby
csv_string = <<-CSV
Id,Username,Email
1,buren,buren@example.com
2,jacob,jacob@example.com
CSV
csv = HoneyFormat::CSV.new(csv_string, type_map: { id: :integer })
csv.columns     # => [:id, :username]
user = csv.rows # => [#<Row id=1, username="buren">]
user.id         # => 1
user.username   # => "buren"

csv.to_csv(columns: [:id, :username]) { |row| row.id < 2 }
# => "id,username\n1,buren\n"
```



**Usage**

By default assumes a header in the CSV file

```ruby
csv_string = "Id,Username\n1,buren"
csv = HoneyFormat::CSV.new(csv_string)

# Header
header = csv.header
header.original # => ["Id", "Username"]
header.columns  # => [:id, :username]


# Rows
rows = csv.rows # => [#<Row id="1", username="buren">]
user = rows.first
user.id         # => "1"
user.username   # => "buren"
```

Set delimiter & quote character
```ruby
csv_string = "name;id|'John Doe';42"
csv = HoneyFormat::CSV.new(
  csv_string,
  delimiter: ';',
  row_delimiter: '|',
  quote_character: "'",
)
```

**Type converters**

> Type converters are great if you want to convert column values, like numbers and dates.

There are a few default type converters
```ruby
csv_string = "Id,Username\n1,buren"
type_map = { id: :integer }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.id # => 1
```

Add your own converter
```ruby
HoneyFormat.configure do |config|
  config.converter_registry.register :upcased, proc { |v| v.upcase }
end

csv_string = "Id,Username\n1,buren"
type_map = { username: :upcased }
csv = HoneyFormat::CSV.new(csv_string, type_map: type_map)
csv.rows.first.username # => "BUREN"
```

Remove registered converter
```ruby
HoneyFormat.configure do |config|
  config.converter_registry.unregister :upcase
  # now you're free to register your own
  config.converter_registry.register :upcase, proc { |v| v.upcase if v }
end
```

Access registered converters
```ruby
decimal_converter = HoneyFormat.converter_registry[:decimal]
decimal_converter.call('1.1') # => 1.1
```

See `Configuration#default_converters`](https://github.com/buren/honey_format/tree/master/lib/honey_format/configuration.rb#L38) for a complete list of the default ones.




### Alternative - Conformist CSV

github: [tatey/conformist](https://github.com/tatey/conformist) ★58, gem: [conformist](https://rubygems.org/gems/conformist)

Let's cheer on Tate Johnson and friends.
The readme says:

Bend CSVs to your will with declarative schemas. Map one or many columns, preprocess cells and lazily enumerate. Declarative schemas are easier to understand, quicker to setup and independent of I/O. Use CSV
or any array of array-like data structure.

**Quick and Dirty Examples**

Open a CSV file and declare a schema. A schema compromises of columns. A column takes an arbitrary name followed by its position in the input. A column may be derived from multiple positions.

``` ruby
require 'conformist'
require 'csv'

csv    = CSV.open '~/transmitters.csv'
schema = Conformist.new do
  column :callsign, 1
  column :latitude, 1, 2, 3
  column :longitude, 3, 4, 5
  column :name, 0 do |value|
    value.upcase
  end
end
```

[...]

**Usage**

**Anonymous Schema**

Anonymous schemas are quick to declare and don't have the overhead of creating an explicit class.

``` ruby
citizen = Conformist.new do
  column :name, 0, 1
  column :email, 2
end

citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```


**Class Schema**

Class schemas are explicit. Class schemas were the only type available in earlier versions of Conformist.

``` ruby
class Citizen
  extend Conformist

  column :name, 0, 1
  column :email, 2
end

Citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```

**Implicit Indexing**

Column indexes are implicitly incremented when the index argument is omitted.
Implicit indexing is all or nothing.

``` ruby
column :account_number                              # => 0
column :date { |v| Time.new *v.split('/').reverse } # => 1
column :description                                 # => 2
column :debit                                       # => 3
column :credit                                      # => 4
```





### Many More Alternatives

That's just a start - there are many more.
Any great alternative CSV libraries missing? Please, tell.




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
