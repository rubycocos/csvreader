# CSV Parser  - What's a Parser? Beyond String#split and Regexp#match

Notes on next / upcoming episode

Three ways to read comma-separated values:

- Use String#split
  - See ruby std lib code - not working :-( for edge cases
- Use a Regular Expression (Regexp) / Text Pattern 
- Use a Parser :-).


google [csv regex pattern](https://google.com/search?q=csv+regex+pattern)



### StackOverflow

Source: https://stackoverflow.com/questions/18144431/regex-to-split-a-csv

Q: Regex to split a CSV?


Comments:

- What about using a proper parser ? 
- Aside from an exercise in curiosity, what made you think of using regex?
- "I've not been able to find a a regex that works 100%" 
  That's mainly because this is a job for a CSV parser, and you should use one.
- Regular expressions are not well-suited to solve this kind of problems, a simple parser will work much better.
  And of course using an existing parser is the easier than writing your own.


<!-- break -->


I'm using this
Regex `/(?<=^|,)(\"(?:[^"]+|"")*\"|[^,]*)(?:$|,)/g`, 
it works with coma separator and double quote escaping. Normally that's should solved your problem.


<!-- break -->

This Regex `(?:^|,)(?=[^"]|(")?)"?((?(1)[^"]*|[^,"]*))"?(?=,|$)`
expression will:

- divide your sample text on the comma delimits
- will process empty values
- will ignore double quoted commas, providing double quotes are not nested
- trims the delimiting comma from the returned value
- trims surrounding quotes from the returned value

Comments:

- Wonderful! It does, however, fail to parse lines like `,,5` correctly - 
  the first empty field is missing. Not sure how to fix this, though. :-( And it is broken on `a,",",a`.
- I don't think this work with escaped quotes `abc,"hello \\"test ", 123`.
- Skips the first field in `"abc""def",ghi`.





### Software Engineering StackExchange


Source: https://softwareengineering.stackexchange.com/questions/166454/can-the-csv-format-be-defined-by-a-regex

Q: Can the csv format be defined by a regex?

A colleague and I have recently argued over whether a pure regex is capable of fully encapsulating the csv format, 
such that it is capable of parsing all files with any given escape char, quote char, and separator char.

The regex need not be capable of changing these chars after creation, but it must not fail on any other edge case.

I have argued that this is impossible. 



A: For example here's the most comprehensive regular expression matching string I've found:

Regular Expressions work as a NDFSM (Non-Deterministic Finite State Machine) 
that wastes a lot of time backtracking once you start adding edge cases like escape chars.


```
re_valid = r"""
# Validate a CSV string having single, double or un-quoted values.
^                                   # Anchor to start of string.
\s*                                 # Allow whitespace before value.
(?:                                 # Group for value alternatives.
  '[^'\\]*(?:\\[\S\s][^'\\]*)*'     # Either Single quoted string,
| "[^"\\]*(?:\\[\S\s][^"\\]*)*"     # or Double quoted string,
| [^,'"\s\\]*(?:\s+[^,'"\s\\]+)*    # or Non-comma, non-quote stuff.
)                                   # End group of value alternatives.
\s*                                 # Allow whitespace after value.
(?:                                 # Zero or more additional values
  ,                                 # Values separated by a comma.
  \s*                               # Allow whitespace before value.
  (?:                               # Group for value alternatives.
    '[^'\\]*(?:\\[\S\s][^'\\]*)*'   # Either Single quoted string,
  | "[^"\\]*(?:\\[\S\s][^"\\]*)*"   # or Double quoted string,
  | [^,'"\s\\]*(?:\s+[^,'"\s\\]+)*  # or Non-comma, non-quote stuff.
  )                                 # End group of value alternatives.
  \s*                               # Allow whitespace after value.
)*                                  # Zero or more additional values
$                                   # Anchor to end of string.
"""
```

It's becomes a nightmare once the common edge-cases are introduced like...

```
"such as ""escaped""","data"
"values that contain /n newline chars",""
"escaped, commas, like",",these"
"un-delimited data like", this
"","empty values"
"empty trailing values",        // <- this is completely valid
                                // <- trailing newline, may or may not be included
```

Comment:

Yup, that's been my experience as well. Any attempt to fully encapsulate more than a very simple CSV pattern
runs into these things, and then you ram up against both the efficiency problems and complexity problems of a massive regex.
Have you looked at the node-csv library? It seems to validate this theory as well.
Every non trivial implementation uses a parser internally. 




