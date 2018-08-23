# Dialects

Comma-separated Values (CSV) formats / variants


## Python (Standard Library) - CSV

Docs: <https://docs.python.org/3/library/csv.html>

> The so-called CSV (Comma Separated Values) format is the most common
> import and export format for spreadsheets and databases. CSV format was used for many years prior
> to attempts to describe the format in a standardized way in RFC 4180. The lack of a well-defined
> standard means that subtle differences often exist in the data produced and consumed by different
> applications. These differences can make it annoying to process CSV files from multiple sources.
> Still, while the delimiters and quoting characters vary, the overall format is similar enough that
> it is possible to write a single module which can efficiently manipulate such data, hiding the
> details of reading and writing the data from the programmer.

### Predefined Dialects:

#### excel
The excel class defines the usual properties of an Excel-generated CSV file. It is registered with the dialect name 'excel'.

#### excel_tab
The excel_tab class defines the usual properties of an Excel-generated TAB-delimited file. It is registered with the dialect name 'excel-tab'.

#### unix_dialect
The unix_dialect class defines the usual properties of a CSV file generated on UNIX systems, i.e. using '\n' as line terminator and quoting all fields. It is registered with the dialect name 'unix'.


### Options:

#### delimiter
A one-character string used to separate fields. It defaults to ','.

#### doublequote
Controls how instances of quotechar appearing inside a field should themselves be quoted. When True, the character is doubled. When False, the escapechar is used as a prefix to the quotechar. It defaults to True.

#### escapechar
A one-character string
removes any special meaning from the following character. It defaults to None, which disables escaping.

#### lineterminator
Note The reader is hard-coded to recognise either '\r' or '\n' as end-of-line, and ignores lineterminator. This behavior may change in the future.

#### quotechar
A one-character string used to quote fields containing special characters, such as the delimiter or quotechar, or which contain new-line characters. It defaults to '"'.

#### quoting
Controls when quotes should be recognised.
QUOTE_NONE: Instructs reader to perform no special processing of quote characters.

#### skipinitialspace
When True, whitespace immediately following the delimiter is ignored. The default is False.

#### strict
When True, raise exception Error on bad CSV input. The default is False.





## Go (Standard Library) - CSV

Docs: <https://golang.org/pkg/encoding/csv>

> Package csv reads and writes comma-separated values (CSV) files.
> There are many kinds of CSV files; this package supports the format
> described in RFC 4180.

### Options:


#### Comma rune

Comma is the field delimiter.
It is set to comma (`,`) by NewReader.
Comma must be a valid rune and must not be `\r`, `\n`,
or the Unicode replacement character (0xFFFD).


#### Comment rune

Comment, if not 0, is the comment character. Lines beginning with the
Comment character without preceding whitespace are ignored.
With leading whitespace the Comment character becomes part of the
field, even if TrimLeadingSpace is true.
Comment must be a valid rune and must not be `\r`, `\n`,
or the Unicode replacement character (0xFFFD).
It must also not be equal to Comma.

#### FieldsPerRecord int


FieldsPerRecord is the number of expected fields per record.
If FieldsPerRecord is positive, Read requires each record to
have the given number of fields. If FieldsPerRecord is 0, Read sets it to
the number of fields in the first record, so that future records must
have the same field count. If FieldsPerRecord is negative, no check is
made and records may have a variable number of fields.


#### LazyQuotes bool

If LazyQuotes is true, a quote may appear in an unquoted field and a
non-doubled quote may appear in a quoted field.


#### TrimLeadingSpace bool

If TrimLeadingSpace is true, leading white space in a field is ignored.
This is done even if the field delimiter, Comma, is white space.



### Errors:

These are the errors that can be returned in ParseError.Err.

-  ErrBareQuote     = errors.New("bare `\"` in non-quoted-field")
-  ErrQuote         = errors.New("extraneous or missing `\"` in quoted-field")
-  ErrFieldCount    = errors.New("wrong number of fields")



## Java (Apache Commons Library) - CSV

Docs: <https://commons.apache.org/csv>


### Predefined Dialects:
#### DEFAULT
Standard comma separated format, as for RFC4180 but allowing empty lines.
Settings are:
- Delimiter(',')
- Quote('"')
- RecordSeparator("\r\n")
- IgnoreEmptyLines(true)

#### EXCEL
Excel file format (using a comma as the value delimiter). Note that the actual value delimiter used by Excel is locale dependent, it might be necessary to customize this format to accommodate to your regional settings. For example for parsing or generating a CSV file on a French system the following format will be used: Delimiter(';').
Settings are:
- Delimiter(',')
- Quote('"')
- RecordSeparator("\r\n")
- IgnoreEmptyLines(false)
Note: this is currently like RFC4180

#### INFORMIX_UNLOAD
Default Informix CSV UNLOAD format used by the UNLOAD TO file_name operation
This is a comma-delimited format with a LF character as the line separator. Values are not quoted and special characters are escaped with '\'. The default NULL string is "\\N".
Settings are:
- Delimiter(',')
- Quote("\"")
- ecordSeparator('\n')
- Escape('\\')

#### INFORMIX_UNLOAD_CSV
Default Informix CSV UNLOAD format used by the UNLOAD TO file_name operation (escaping is disabled)
This is a comma-delimited format with a LF character as the line separator. Values are not quoted and special characters are escaped with '\'. The default NULL string is "\\N".
Settings are:
- Delimiter(',')
- Quote("\"")
- RecordSeparator('\n')

#### MYSQL
Default MySQL format used by the SELECT INTO OUTFILE and LOAD DATA INFILE operations
This is a tab-delimited format with a LF character as the line separator. Values are not quoted and special characters are escaped with '\'. The default NULL string is "\\N".
Settings are:
- Delimiter('\t')
- Quote(null)
- RecordSeparator('\n')
- IgnoreEmptyLines(false)
- Escape('\\')
- NullString("\\N")
- QuoteMode(QuoteMode.ALL_NON_NULL)

#### POSTGRESQL_CSV
Default PostgreSQL CSV format used by the COPY operation
This is a comma-delimited format with a LF character as the line separator. Values are double quoted and special characters are escaped with '"'. The default NULL string is "".
Settings are:
- Delimiter(',')
- Quote('"')
- RecordSeparator('\n')
- IgnoreEmptyLines(false)
- Escape('\\')
- NullString("")
- QuoteMode(QuoteMode.ALL_NON_NULL)

#### POSTGRESQL_TEXT
Default PostgreSQL text format used by the COPY operation
This is a tab-delimited format with a LF character as the line separator. Values are double quoted and special characters are escaped with '"'. The default NULL string is "\\N".
Settings are:
- Delimiter('\t')
- withQuote('"')
- RecordSeparator('\n')
- IgnoreEmptyLines(false)
- Escape('\\')
- NullString("\\N")
- QuoteMode(QuoteMode.ALL_NON_NULL)

#### RFC4180
Comma separated format as defined by RFC 4180.
Settings are:
- Delimiter(',')
- Quote('"')
- RecordSeparator("\r\n")
- IgnoreEmptyLines(false)

#### TAB
Tab (\t)-separated format
Settings are:
- Delimiter('\t')
- Quote('"')
- RecordSeparator("\r\n")
- IgnoreSurroundingSpaces(true)


### Options:

#### CommentMarker(char commentMarker)
Returns a new CSVFormat with the comment start marker of the format set to the specified character

#### Delimiter(char delimiter)
Returns a new CSVFormat with the delimiter of the format set to the specified character.

#### Escape(char escape)
Returns a new CSVFormat with the escape character of the format set to the specified character.

#### IgnoreEmptyLines(boolean ignoreEmptyLines)
Returns a new CSVFormat with the empty line skipping behavior of the format set to true.

#### IgnoreSurroundingSpaces(boolean ignoreSurroundingSpaces)
Returns a new CSVFormat with the trimming behavior of the format set to true.

#### NullString(String nullString)
Returns a new CSVFormat with conversions to and from null for strings on input and output.

#### Quote(char quoteChar)
Returns a new CSVFormat with the quoteChar of the format set to the specified character.

#### QuoteMode(QuoteMode quoteModePolicy)
Returns a new CSVFormat with the output quote policy of the format set to the specified value.

#### RecordSeparator(char recordSeparator)
Returns a new CSVFormat with the record separator of the format set to the specified character.

#### TrailingDelimiter(boolean trailingDelimiter)
Returns a new CSVFormat with whether to add a trailing delimiter.

#### Trim(boolean trim)
Returns a new CSVFormat with whether to trim leading and trailing blanks.



## Tabular Data Package - Frictionless Data - CSV Dialect

Docs: <https://frictionlessdata.io/specs/csv-dialect>


### Options
#### delimiter
specifies the character sequence which should separate fields (aka columns).
Default = ,. Example \t.

#### lineTerminator
specifies the character sequence which should terminate rows.
Default = \r\n

#### quoteChar
specifies a one-character string to use as the quoting character.
Default = "
#### doubleQuote
controls the handling of quotes inside fields. If true, two consecutive quotes should be interpreted as one.
Default = true

#### escapeChar
specifies a one-character string to use for escaping (for example, \), mutually exclusive with
quoteChar.
Not set by default

#### nullSequence
specifies the null sequence (for example \N).
Not set by default

#### skipInitialSpace
specifies how to interpret whitespace which immediately follows a delimiter; if false, it means that whitespace immediately after a delimiter should be treated as part of the following field.
Default = true


## JavaScript csv-parse

Docs: <http://csv.adaltas.com/parse>


### comment (char)
Treat all the characters after this one as a comment. Defaults to '' (disabled).

### delimiter (char)
Set the field delimiter. One character only. Defaults to "," (comma).

### escape (char)
Set the escape character. One character only. Defaults to double quote.

### max_limit_on_data_read (int)
Maximum numer of characters to be contained in the field and line buffers before an exception is raised. Used to guard against a wrong delimiter or rowDelimiter. Default to 128,000 characters.

### quote (char|boolean)
Optional character surrounding a field. One character only. Disabled if null, false or empty. Defaults to double quote.

### relax (boolean)
Preserve quotes inside unquoted field (be warned, it doesn't make coffee).

### rowDelimiter (chars|array)
One or multiple characters used to delimit record rows; defaults to auto discovery if not provided. Suported auto disvovery method are Linux ("\n"), Apple ("\r") and Windows ("\r\n") row delimiters.

### skip_empty_lines (boolean)
Don't generate records for empty lines (line matching /\s*/), defaults to false.
skip_lines_with_error (boolean)
Skip a line with error found inside and directly go process the next line.

### skip_lines_with_empty_values (boolean)
Don't generate records for lines containing empty column values (column matching /\s*/), defaults to false.

### trim (boolean)
If true, ignore whitespace immediately around the delimiter. Defaults to false. Does not remove whitespace in a quoted field.

#### ltrim (boolean)
If true, ignore whitespace immediately following the delimiter (i.e. left-trim all fields). Defaults to false. Does not remove whitespace in a quoted field.

#### rtrim (boolean)
If true, ignore whitespace immediately preceding the delimiter (i.e. right-trim all fields). Defaults to false. Does not remove whitespace in a quoted field.
