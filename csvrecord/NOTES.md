# Notes



## More CSV Libraries

<https://github.com/pcreux/csv-importer>

<https://github.com/eval/csv-omg>





# CSV Notes

todo: move to awesome csv page - why? why not?

- <https://www.ietf.org/rfc/rfc4180.txt> - RFC 4180, Common Format and MIME Type for CSV Files,    October 2005

(Augmented) Backus-Naur Form (BNF) Grammar:

```
file        = [header CRLF] record *(CRLF record) [CRLF]
header      = name *(COMMA name)
record      = field *(COMMA field)
name        = field
field       = (escaped / non-escaped)
escaped     = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
non-escaped = *TEXTDATA
COMMA       = %x2C
CR          = %x0D
DQUOTE      = %x22
LF          = %x0A
CRLF        = CR LF
TEXTDATA    = %x20-21 / %x23-2B / %x2D-7E
```


- <https://www.w3.org/TR/2015/REC-tabular-data-model-20151217/> - Model for Tabular Data and Metadata on the Web, W3C Recommendation 17 December 2015

(Extended) Backus-Naur Form (BNF) Grammar:

```
[1]	csv      ::=	header record+
[2]	header   ::=	record
[3]	record   ::=	fields #x0D? #x0A
[4]	fields   ::=	field ("," fields)*
[5]	field    ::=	WS* rawfield WS*
[6]	rawfield ::=	'"' QCHAR* '"' |SCHAR*
[7]	QCHAR    ::=	[^"] |'""'
[8]	SCHAR    ::=	[^",#x0A#x0D]
[9]	WS       ::=	[#x20#x09]
```


Notes on Microsoft Excel Spreadsheets:

Save

Excel generates CSV files encoded using Windows-1252 with LF line endings. Characters that cannot be represented within Windows-1252 are replaced by underscores. Only those cells that need escaping (e.g. because they contain commas or double quotes) are escaped, and double quotes are escaped with two double quotes.
Dates and numbers are formatted as displayed, which means that formatting can lead to information being lost or becoming inconsistent.


Open / Read

When opening CSV files, Excel interprets CSV files saved in UTF-8 as being encoded as Windows-1252 (whether or not a BOM is present). It correctly deals with double quoted cells, except that it converts line breaks within cells into spaces. It understands CRLF as a line break. It detects dates (formatted as YYYY-MM-DD) and formats them in the default date formatting for files.


Wikipedia
- <https://en.wikipedia.org/wiki/Comma-separated_values>

More

<https://www.csvreader.com/csv_format.php>

Use unix-style escape rules
- no quotes required!!!
- \,  => e.g.  apples\, carrots\, and oranges
- \\  for "escaped" literal backslash
- \n  for newline (LF) and
- \r  for carriage return (CR)
- \s  - use for space - why? why not?
- DO NOT USE - \N  - use for Null - why? why not?  -- conflicts easy with \n, thus, NOT recommended - AVOID - DO NOT USE!!!!
- allow  \### and \o### Octal, \x## Hex, \d### Decimal, and \u#### Unicode - why? why not?




"Rules" about spaces:

- recommendation: (always) trim leading and trailing spaces!!!!
  - note: frictionless data "csv dialects" only allow trim leading space (e.g. `skipInitialSpace`)

"Rules" about unknown unknowns (nil) and known unknowns (missing)

- recommendation:  use a special letter e.g. `?`  for marking **known** unknowns and
- use `""` or empty or `NA` or `n/a` etc. for "classic" null values (e.g. unknown unknowns)



- Allow comments starting with `#`
- Skip blank lines (white space trimmed)
  - is  ,,, a blank line? or four nulls?



# Go Csv Library

<https://golang.org/pkg/encoding/csv/>

dialect options include:

```
// Comma is the field delimiter.
        // It is set to comma (',') by NewReader.
        // Comma must be a valid rune and must not be \r, \n,
        // or the Unicode replacement character (0xFFFD).
        Comma rune

        // Comment, if not 0, is the comment character. Lines beginning with the
        // Comment character without preceding whitespace are ignored.
        // With leading whitespace the Comment character becomes part of the
        // field, even if TrimLeadingSpace is true.
        // Comment must be a valid rune and must not be \r, \n,
        // or the Unicode replacement character (0xFFFD).
        // It must also not be equal to Comma.
        Comment rune

        // FieldsPerRecord is the number of expected fields per record.
        // If FieldsPerRecord is positive, Read requires each record to
        // have the given number of fields. If FieldsPerRecord is 0, Read sets it to
        // the number of fields in the first record, so that future records must
        // have the same field count. If FieldsPerRecord is negative, no check is
        // made and records may have a variable number of fields.
        FieldsPerRecord int

        // If LazyQuotes is true, a quote may appear in an unquoted field and a
        // non-doubled quote may appear in a quoted field.
        LazyQuotes bool

        // If TrimLeadingSpace is true, leading white space in a field is ignored.
        // This is done even if the field delimiter, Comma, is white space.
        TrimLeadingSpace bool
```


``` go
package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"strings"
)

func main() {
	in := `first_name;last_name;username
"Rob";"Pike";rob
# lines beginning with a # character are ignored
Ken;Thompson;ken
"Robert";"Griesemer";"gri"
`
	r := csv.NewReader(strings.NewReader(in))
	r.Comma = ';'
	r.Comment = '#'

	records, err := r.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Print(records)
}
```


More about CSV

- <http://www.creativyst.com/Doc/Articles/CSV/CSV01.htm>
- <http://www.creativyst.com/Doc/Std/ctx/ctx.htm> altenative "extentend" csv format (uses always pipes `|` for separator)

e.g.

```
\TPersons|People Table|Pet owners in our example db|Pet owners|||
\LNumber|LastName|FirstName
\NPerson Number|Last Name|First Name
\QNUMBER(7)|VARCHAR(65)|CHAR(35)
1|Smythe|Jane
2|Doe|John
3|Mellonhead|Creg
```


## CSV Format

The CSV Format:
- **Each record is one line** - Line separator may be LF (0x0A) or CRLF (0x0D0A), a line separator may also be embedded in the data (making a record more than one line but still acceptable).
- **Fields are separated with commas.** - Duh.
- **Leading and trailing whitespace is ignored** - Unless the field is delimited with double-quotes in that case the whitespace is preserved.
- **Embedded commas** - Field MUST be delimited with double-quotes.
- **Embedded double-quotes** - Embedded double-quote characters MUST be doubled, and the field must be delimited with double-quotes.
- **Embedded line-breaks** - Fields MUST be surrounded by double-quotes.

Source <http://edoceo.com/utilitas/csv-file-format>


## CSV Formats

This utility supports two flavors of CSV:

#### UNIX Style

- backslash escape character for quotes (\"), new lines (\n), and backslashes (\\)
- Each record must be on its own line. If a field contains a new line, the new line must be escaped.
- Leading and trailing white space on an unquoted field is ignored.
- Compatible with standard unix text processing tools such as grep and sed that work on a line by line basis.


#### Microsoft Excel Style

- Two quotes escape character ("" escapes "), no other characters are escaped.
- Compatible with Microsoft Excel and many other programs that have adopted the format for data import and export.
- Leading and trailing white space on an unquoted field is significant.
- Specified by RFC4180.

Note that for simple field data that does not contain quotes or new lines, the two formats are fairly equivalent.



## CSV Format

```
apple,"wild cherry",peach
pear,plum,"apricot"
mango,payaya,guava
"orange, Valencia",  lemon, lime
"""extra virgin"" olive", palm, date
```

Usually fields containing embedded spaces or commas
are contained in " marks, but there are other conventions.
Quotes (") inside quoted fields are doubled.


## CSV Variations

Behaviors of this program that often vary between CSV implementations:

- Newlines are supported in quoted fields.
- Double quotes are permitted in a non-quoted field. However, a field starting with a quote must follow quoting rules.
- Each record can have a different numbers of fields.
- The three common forms of newlines are supported: CR, CRLF, LF.
- A newline will be added if the file does not end with one.
- No whitespace trimming is done.

