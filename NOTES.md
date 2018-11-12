# Notes

## Todos

- [ ]  add option for allow newlines in quotes/quoted values (yes/no) - turned on by default? (as is now)
- [ ]  add null values/na option
- [ ]  add unix-style backslash escape
- [ ]  add support for converters (see std csv library)
- [ ]  add Csv shortcuts e.g. Csv.read, etc.
- [ ]  hash reader - add rest and rest_value for how to handle missing values?
- [ ]  hash reader - handle duplicate header names - how?
- [ ]  hash reader - handle empty header names - how?
- [ ]  add support for tracking line number, record number, field number etc. (useful for errors etc.)



## Readme

Add - why? why not?


### Fixed Width Fields

Bonus: If the width is a string (not an array)
(e.g. `'a8 a8 a32 Z*'` or `'A8 A8 A32 Z*'` and so on)
than the fixed width field parser
will use  `String#unpack` and the value of width as its format string spec.
Example:

``` ruby
txt = <<TXT
12345678123456781234567890123456789012345678901212345678901234
TXT

Csv.fixed.parse( txt, width: 'a8 a8 a32 Z*' )  # or Csv.fix or Csv.f
# => [["12345678","12345678", "12345678901234567890123456789012", "12345678901234"]]

txt = <<TXT
John    Smith   john@example.com                1-888-555-6666
Michele O'Reileymichele@example.com             1-333-321-8765
TXT

Csv.fixed.parse( txt, width: 'A8 A8 A32 Z*' )   # or Csv.fix or Csv.f
# => [["John",    "Smith",    "john@example.com",    "1-888-555-6666"],
#     ["Michele", "O'Reiley", "michele@example.com", "1-333-321-8765"]]

# and so on
```

| String Directive | Returns | Meaning                 |
|------------------|---------|-------------------------|
| `A`              | String  | Arbitrary binary string (remove trailing nulls and ASCII spaces) |
| `a`              | String  | Arbitrary binary string |
| `Z`              | String  | Null-terminated string  |


and many more. See the `String#unpack` documentation
for the complete format spec and directives.













## More csv readers in ruby

### Hippie CSV

<https://github.com/intercom/hippie_csv> - Tolerant, liberal CSV parsing

if you want to be able to deal with files from the real world. At Intercom, we’ve seen lots of problematic CSVs from customers importing data to our system. You may want to support such cases. You may not always know the delimiter, nor the chosen quote character, in advance.

HippieCSV is a ridiculously tolerant and liberal parser which aims to yield as much usable data as possible out of such real-world CSVs.

Features:
- Deduces the delimiter (supports ,, ;, and \t)
- Deduces the quote character (supports ', ", and |)
- Forgives backslash escaped quotes in quoted CSVs
- Forgives invalid newlines in quoted CSVs
- Heals many encoding issues (and aggressively forces UTF-8)
- Deals with many miscellaneous malformed types of CSVs
- Works when a byte order mark is present


Note: uses CSV std lib with parse_line (line by line parsing)

``` ruby
QUOTE_CHARACTERS = %w(" ' | ∑ ⦿ ◉).freeze
  # The latter three characters are not expected to intentionally used as
  # quotes. Rather, when usual quote characters are badly misused, we want
  # to fall back to a character _unlikely_ to be in the file, such that
  # we can at least parse.

DELIMETERS = %W(, ; \t).freeze

def maybe_parse(string)
        encoded_string = encode(string)

        QUOTE_CHARACTERS.find do |quote_character|
          [encoded_string, tolerate_escaping(encoded_string, quote_character), dump_quotes(encoded_string, quote_character)].find do |string_to_parse|
            rescuing_malformed do
              return parse_csv(string_to_parse.squeeze("\n").strip, quote_character)
            end
          end
        end
end

def tolerate_escaping(string, quote_character)
  string.gsub("\\#{quote_character}", "#{quote_character}#{quote_character}")
end

def guess_delimeter(string, quote_character)
        results = DELIMETERS.map do |delimeter|
          [delimeter, field_count(string, delimeter, quote_character)]
        end.max_by do |delimeter, count|
          count
        end.each do |delimiter, count|
          return delimiter
        end
end  

def field_count(file, delimeter, quote_character)
        csv = CSV.new(file, col_sep: delimeter, quote_char: quote_character)
        csv.lazy.take(FIELD_SAMPLE_COUNT).map(&:size).inject(:+)
      rescue CSV::MalformedCSVError
        0
end
```


### Lenient CSV

<https://github.com/sj26/lenientcsv> - Lenient CSV parsing


``` ruby
def scan_row
  row = []
  loop do
    if value = scan_field
      row << value
    end

    if @scanner.scan /,/
      next
    elsif @scanner.scan /\r?\n/ or @scanner.eos?
      return row
    else
      raise "Malformed row at #{@scanner.inspect}"
    end
  end
end

def scan_field
  scan_quoted_field or
    scan_unquoted_field
end

def scan_quoted_field
  if @scanner.scan /"/
    value = ""
    loop do
      if @scanner.scan /[^\\"]+/
        value << @scanner.matched
      # Unix-style quoting
      # (Don't care about "\t" => <tab>)
      elsif @scanner.scan /\\/
        value << @scanner.getch
      # CSV RFC 4180-style quoting
      elsif @scanner.scan /""/
        value << '"'
      elsif @scanner.scan /"/
        return value
      else
        raise "unexpected EOF inside quoted value #{@scanner.inspect}"
      end
    end
  end
end

def scan_unquoted_field
  @scanner.scan /[^,\r\n]*/
end
```



### WTF CSV

<https://github.com/gremerritt/wtf_csv> - detect formatting issues in a CSV


`WtfCSV.scan` has the following options:
```
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| Option                          | Default  |  Explanation                                                                         |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :col_sep                        |   ','    | Column separator                                                                     |
| :row_sep                        | $/ ,"\n" | Row separator - defaults to system's $/ , which defaults to "\n"                     |
| :quote_char                     |   '"'    | Quotation character                                                                  |
| :escape_char                    |   '\'    | Character to escape quotes                                                           |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :check_col_count                |   true   | If set, checks for issues in the number of columns that are present                  |
| :num_cols                       |    0     | If :check_col_count is set and this value is non-zero, will return errors if any     |
|                                 |          | line does not have this number of columns                                            |
| :col_threshold                  |    80    | If :check_col_count is set, this is the percentage of rows that must have a column   |
|                                 |          | count in order for the module to assume this is the target number of columns.        |
|                                 |          |   For example, if there are 10 line in the file, and this value is set to 80, then   |
|                                 |          |   at least 8 lines must have a certain number of columns for the module to assume    |
|                                 |          |   this is the number of columns that rows are supposed to have                       |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :ignore_string                  |   nil    | If a line is equal to this string, the line will not be checked for issues           |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :allow_row_sep_in_quoted_fields |  false   | Allows :row_sep characters to be present in quoted fields. Otherwise if there are    |
|                                 |          | line ending characters in a field, they will be treat as sequential lines and you'll |
|                                 |          | likely receive column count errors (if you're checking for them)                     |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :max_chars_in_field             |   nil    | Ensures that fields have less than or equal to the provided number of characters     |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
| :file_encoding                  | 'utf-8'  | Set the file encoding                                                                |
|---------------------------------|----------|--------------------------------------------------------------------------------------|
```


``` ruby
def WtfCSV.scan(file, options = {}, &block)
  default_options = {
    :col_sep => ',',
    :row_sep => $/,
    :quote_char => '"',
    :escape_char => '\\',
    :check_col_count => true,
    :col_threshold => 80,
    :num_cols => 0,
    :ignore_string => nil,
    :allow_row_sep_in_quoted_fields => false,
    :max_chars_in_field => nil,
    :file_encoding => 'utf-8',
  }
  options = default_options.merge(options)

  f = File.open(file, "r:#{options[:file_encoding]}")
  trgt_line_count = `wc -l "#{file}"`.strip.split(' ')[0].to_i if block_given?

  # credit to tilo, author of smarter_csv, on how to loop over lines without reading whole file into memory
  old_row_sep = $/
  $/ = options[:row_sep]

  quote_errors = Array.new
  encoding_errors = Array.new
  column_errors = Array.new
  column_counts = Array.new if options[:check_col_count]
  length_errors = Array.new

  line_number = 0
  col_number = 0
  percent_done = 0
  previous_line = ""
  last_line_ended_quoted = false if options[:allow_row_sep_in_quoted_fields]
  field_length = 0 if ! options[:max_chars_in_field].nil?

  begin
    while ! f.eof?
      line = f.readline
      begin
        if block_given? and ((line_number.to_f / trgt_line_count)*100).to_i > percent_done
          percent_done = ((line_number.to_f / trgt_line_count)*100).to_i
          yield percent_done
        end

        line.chomp!

        next if ! options[:ignore_string].nil? and line == options[:ignore_string]

        if options[:allow_row_sep_in_quoted_fields] and last_line_ended_quoted
          line_number -= 1
          last_line_ended_quoted = false
          field_length += options[:row_sep].length if ! options[:max_chars_in_field].nil?
        else
          is_quoted = false
          new_col = true
          quote_has_ended = false
          quote_error = false
          escape_char = false
          col_number = 0
        end
        pos_start = 0

        line.each_char.with_index do |char, position|
          begin
            char.ord  # this is here to check encoding. if the encoding is bad this will throw an exception

            field_length += 1 if ! options[:max_chars_in_field].nil?

            if escape_char and options[:escape_char] == options[:quote_char] and char != options[:quote_char]
              escape_char = false
              is_quoted = ! is_quoted
              if ! is_quoted
                quote_has_ended = true
              elsif ! new_col
                quote_error = true
                is_quoted = false
              end
            end

            if char != options[:quote_char] and char != options[:col_sep] and char != options[:escape_char] ## escape_char part
              new_col = false
              if quote_has_ended
                quote_error = true
              end
            elsif char == options[:quote_char] and escape_char
              escape_char = false
            elsif char == options[:escape_char]
              escape_char = true
            elsif char == options[:quote_char] and is_quoted
              quote_has_ended = true
              is_quoted = false
            elsif char == options[:quote_char]
              if new_col
                is_quoted = true
                new_col = false
              else
                quote_error = true
              end
            elsif char == options[:col_sep] and ! is_quoted
              if quote_error
                quote_errors.push([line_number + 1,col_number + 1,"#{previous_line}#{line[pos_start..(position - 1)]}"])
                quote_error = false
              end
              if ! options[:max_chars_in_field].nil?
                length_errors.push([line_number + 1,col_number + 1,field_length - 1]) if (field_length - 1) > options[:max_chars_in_field]
                field_length = 0
              end
              new_col = true
              quote_has_ended = false
              previous_line = ""
              pos_start = position + 1
              col_number += 1
            end
          rescue Exception => e
            if e.message == 'invalid byte sequence in UTF-8'
              encoding_errors.push([line_number + 1,col_number + 1])
            end
          end
        end

        if escape_char and options[:escape_char] == options[:quote_char]
          if ! new_col and ! is_quoted
            quote_error = true
          else
            is_quoted = ! is_quoted
          end
        end

        if is_quoted
          if options[:allow_row_sep_in_quoted_fields]
            last_line_ended_quoted = true
            previous_line = "#{previous_line}#{line[pos_start...line.length]}#{options[:row_sep]}"
            next
          else
            quote_error = true
          end
        end

        quote_errors.push([line_number + 1,col_number + 1,line[pos_start..line.length]]) if quote_error

        if ! options[:max_chars_in_field].nil?
          length_errors.push([line_number + 1,col_number + 1,field_length]) if field_length > options[:max_chars_in_field]
          field_length = 0
        end

        if options[:check_col_count]
          fnd = false
          column_counts.each do |val|
            if val[0] == col_number + 1
              val[1].push(line_number)
              fnd = true
              break
            end
          end

          if ! fnd
            column_counts.push([col_number + 1, [line_number + 1]])
          end
        end

      rescue Exception => e
        # don't do anything
      ensure
        line_number += 1
      end
    end
  ensure
    $/ = old_row_sep
  end

  if options[:check_col_count]
    column_counts.sort_by! { |val| val[1].length }
    column_counts.reverse!

    # if we're looking for an absolute number...
    if options[:num_cols] != 0
      column_counts.each do |val|
        if val[0] != options[:num_cols]
          val[1].each { |row| column_errors.push([row,val[0],options[:num_cols]]) }
        end
      end

    # else we'll try to figure out the target number of columns with :col_threshold
    elsif column_counts.length > 1
      if column_counts[0][1].length >= line_number * (options[:col_threshold].to_f / 100)
        column_counts.drop(1).each { |val| val[1].each { |row| column_errors.push([row,val[0],column_counts[0][0]]) } }
      else
        column_counts.each { |val| column_errors.push([val[0],val[1].length]) }
      end
    end
  end

  return {:quote_errors => quote_errors,
          :encoding_errors => encoding_errors,
          :column_errors => column_errors,
          :length_errors => length_errors}

end
```




## Add more reader / parsers

- include TabReader
- add new RecordReader
  - works like TabReader but lets you change the separator (support unix escapes? and quotes? why? why not?)
- check use either doubled quotes or unix-style escapes (format possible/exists? with both??)

- note: if you use always quotes - no harm in trim or ignore blank lines or comments (backwards/forwards compabitle!!)



## Auto-Detect / Guess Separator

add auto-detect/guess separator

- count all candidate seps e.g. `,` `;` `|` `:` `\t`
- count all non-alphanumeric chars?
- count per line (see if equal/tabular?)
- check for quotes  and doubled quotes (`""`)
- check for unix-style escape e.g. `\" \, \n \r`

- algorithm / heuristic - what to use?

- skip comments
- skip blank lines



## More CSV Tools   - csvcount / csvquery

add a csvcount or csvcnt or csvc  (inspired by wc or word count)

- count number of records / lines
- count number of fields / chars
- count number

e.g try:

`csvc *`  or `csv **`   for completee directory (`*`) or complete directory tree (`**`)


add a csvq  or csvquery  tool

-  works like grep - search for regex in complete line or column
- use -c/--col(umns) flags to list columns? to include search for e.g. -c team1,team2
- search for complete directory (`*`) or complete directory tree (`**`)
- why?
  - always ignores quoted values e.g. "Hallo", searches just (unquoted) value Hallo and so on
