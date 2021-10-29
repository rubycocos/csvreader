# Migrate / Upgrade from Smarter CSV to CSV Reader - Side-by-Side Examples



## What's Smarter CSV?

SmarterCSV is a ruby library for (smarter) reading CSV datafile. SmarterCSV "pioneered" returning "ye plain olde" arrays of hashes
for records (instead of using custom `CSV::Table`, `CSV::Row`, etc.).

> Ruby's CSV library's API is pretty old, and it's processing of CSV-files returning Arrays of Arrays feels 'very close to the metal'.
> The output is not easy to use - especially not if you want to create database records from it. 
> [...]
> As the existing CSV libraries didn't fit my needs, I was writing my own CSV processing - specifically for use 
> in connection with Rails ORMs like Mongoid, MongoMapper or ActiveRecord. 
> In those ORMs you can easily pass a hash with attribute/value pairs to the create() method. 
> The lower-level Mongo driver and Moped also accept larger arrays of such hashes 
> to create a larger amount of records quickly with just one call.
>
> (Source: [SmarterCSV README](https://github.com/tilo/smarter_csv))

However, under the hood the SmarterCSV is NOT so smart. Why? Surprise, surprise - yes, it's using the CSV standard library 
for the "heavy-duty" parsing. Bad. Bad. Bad. 
See the ongoing [Why the CSV standard library is broken (and how to fix it)](https://github.com/csvreader/docs)
article series for an inside look into the unfixable `String#split` parser kludge and much more.  


Anyways, let's copy-n-paste the [Getting Started w/ Smarter CSV - The Basics](https://github.com/tilo/smarter_csv/wiki/The-Basics) 
document right here 
and let's add the CSV Reader alternative.
Here we go:

- [Vanilla CSV Files](#vanilla-csv-files)
- [Another Vanilla CSV File](#another-vanilla-csv-file)
- [But my CSV Files are not Comma-Separated](#but-my-csv-files-are-not-comma-separated)
- [But I don't want Symbols as Keys](#but-i-dont-want-symbols-as-keys)
- [But I want the RAW headers!](#but-i-want-the-raw-headers)



## Vanilla CSV Files

If you have a vanilla CSV file which is comma separated, and has standard line endings.

```
$ cat  /tmp/test.csv
"CATEGORY " ," FIRST  NAME" , " AGE "
 "Red","John" , " 34 "
```

Reading and processing the CSV file is straight-forward, and you get an array of hashes containing the data:

``` ruby
data = SmarterCSV.process( filename )
#=> [{:category=>"Red", :first_name=>"John", :age=>"34"}]
```

You will notice that the sample CSV file had a couple of extra spaces, which were stripped off, and the fields from the header line were converted into Ruby symbols.
Notice how the double-space in " FIRST  NAME" becomes an underscore in :first_name.

All this is default behavior, assuming that you want to hand this data to an ORM, but these defaults can be overwritten.


---

**Migrate / Upgrade to CSV Reader.**

``` ruby
options = { :header_converter => :symbol }

data = CsvHash.read( filename, options )
#=> [{:category=>"Red", :first_name=>"John", :age=>"34"}]

# -or-

CsvHash.config.header_converter = :symbol    # change "global" default reader settings

data = CsvHash.read( filename )
#=> [{:category=>"Red", :first_name=>"John", :age=>"34"}]
```

Note: In the CSV Reader library use `CsvHash` to get an array of hashes returned. 
Use the `:symbol` header converter keyword option to turn headers into symbols.
Or you can use `CsvHash.config` for changing the "global" default reader settings.

---




## Another Vanilla CSV File

This sample file has a few fields empty, and one row without any values.

```
$ cat /tmp/pets.csv
first name,last name,dogs,cats,birds,fish
Dan,McAllister,2,,,
,,,,,
Lucy,Laweless,,5,,
Miles,O'Brian,,,,21
Nancy,Homes,2,,1,

$ irb
 > require 'smarter_csv'
 > pets_by_owner = SmarterCSV.process('/tmp/pets.csv')
  => [ {:first_name=>"Dan", :last_name=>"McAllister", :dogs=>"2"}, 
       {:first_name=>"Lucy", :last_name=>"Laweless", :cats=>"5"}, 
       {:first_name=>"Miles", :last_name=>"O'Brian", :fish=>"21"}, 
       {:first_name=>"Nancy", :last_name=>"Homes", :dogs=>"2", :birds=>"1"}
     ]
 
 > SmarterCSV.warnings
  => {3=>["No data in line 3"]}
 > SmarterCSV.errors
  => {}
```

Another default behavior of SmarterCSV is that it will remove any key/value pairs from the result hash if the value is nil or an empty string. The reasoning here is that if you would update a database record containing valid data with an empty string, you would destroy data. SmarterCSV is trying to be safe here, and avoid this scenario by default. But this default behavior can be changed if needed.

You'll also notice that there is a way to get any errors or warnings which may occur during processing.
In this case, there was no data in line 3 - all the values were empty.


---

**Migrate / Upgrade to CSV Reader.**

``` ruby
options = { :header_converter => :symbol,
            :remove_blanks    => true }

pets_by_owner = CsvHash.read( '/tmp/pets.csv', options )
#=> [{:first_name=>"Dan", :last_name=>"McAllister", :dogs=>"2"}, 
#    {:first_name=>"Lucy", :last_name=>"Laweless", :cats=>"5"}, 
#    {:first_name=>"Miles", :last_name=>"O'Brian", :fish=>"21"}, 
#    {:first_name=>"Nancy", :last_name=>"Homes", :dogs=>"2", :birds=>"1"}]

# -or-

pets_by_owner = CsvHash.read( '/tmp/pets.csv' )   # with "global" default reader settings changed (see above)
#=> [{:first_name=>"Dan", :last_name=>"McAllister", :dogs=>"2"}, 
#    {:first_name=>"Lucy", :last_name=>"Laweless", :cats=>"5"}, 
#    {:first_name=>"Miles", :last_name=>"O'Brian", :fish=>"21"}, 
#    {:first_name=>"Nancy", :last_name=>"Homes", :dogs=>"2", :birds=>"1"}]
```

Note:  Use the `:remove_blanks` keyword option to remove blank values and all blank records.

---



## But my CSV Files are not Comma-Separated

```
$ cat /tmp/test2.csv
"CATEGORY";"FIRST--NAME";"AGE"
"Red";"John";"35"
```

To read this file, we just need to tell SmarterCSV which column-separator `col_sep` to use.

``` ruby
data = SmarterCSV.process('/tmp/test.csv', {col_sep: ';'})
#=> [{:category=>"Red", :first_name=>"John", :age=>"35"}]
```

Notice how the double-dash becomes an underscore in `:first_name`.


---

**Migrate / Upgrade to CSV Reader.**

``` ruby
CsvHash.config.header_converter = :symbol 

data = CsvHash.read( '/tmp/test.csv', sep: ';' )
#=> [{:category=>"Red", :first_name=>"John", :age=>"35"}]
```

Note:  You can use `CsvHash.config` for changing the "global" default reader settings.

---



## But I don't want Symbols as Keys

If you don't want symbols as Keys, you can just pass this option in:

``` ruby
data = SmarterCSV.process('/tmp/test.csv', {header_transformations: [:none, :keys_as_strings]})
#=> [{"category"=>"Red", "first_name"=>"John", "age"=>"35"}]
```

Again, the default is to strip whitespaces and downcase the headers, because ORMs in Ruby have lower-case attribute names.

The keyword `:none` disables any defaults for `header_transformations`, before we specify `:keys_as_strings`.



---

**Migrate / Upgrade to CSV Reader.**

``` ruby
data = CsvHash.read( '/tmp/test.csv' )
#=> [{"category"=>"Red", "first_name"=>"John", "age"=>"35"}]

```

Note: The CSV Reader uses string keys as default.
Use the `:downcase` header converter keyword option to explicitly change the setting.

---



<!--

note: removed binary field and record separator example for now 
-->




## But I want the RAW headers!

``` ruby
data = SmarterCSV.process('/tmp/test.csv', {header_transformations: [:none]})
#=> [{"CATEGORY "=>"Red", " FIRST  NAME"=>"John", " AGE "=>"35"}]
```

Congrats! Now you have to strip those spaces yourself.



---

**Migrate / Upgrade to CSV Reader.**

``` ruby
data = CsvHash.read( '/tmp/test.csv', :header_converter => :none )
#=> [{"CATEGORY "=>"Red", " FIRST  NAME"=>"John", " AGE "=>"35"}]
```

Note: Use the `:none` header converter keyword option for getting the "RAW" headers.

---


That's it. Find out more about the [CSV Reader Library »](https://github.com/csvreader/csvreader).

