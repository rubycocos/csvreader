# Notes


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



