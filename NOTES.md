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
