# Why the CSV standard library is broken (and how to fix it), Part V or Escaping the Stray Quote Error Hell - Do You Want Single, Double, or French Quotes With That Comma?

What's broken (and wrong, wrong, wrong) with the CSV standard library? Let's count the ways.


Start with the (complete) series:
- **[Part I or A (Simplistic) String#split Kludge vs A Purpose Built CSV Parser »](why-the-csv-stdlib-is-broken.md)**
- **[Part II or The Wonders of CSV Formats / Dialects »](csv-formats.md)**
- **[Part III or Returning a CSV Record as an Array? Hash? Struct? Row? »](csv-array-hash-struct.md)**
- **[Part IV or Numerics a.k.a. Auto-Magic Type Inference for Strings and Numbers »](csv-numerics.md)**



## What about Quotes and Comma-Separated Values (CSV)?


Remember the rule no. 3 that
when you want to use a comma in your value
you MUST put your value in (double) quotes.
And rule no. 4 that when you want to use a quote in your quote
you MUST double the (double) quote.
Let's turn Shakespeare's Hamlet quote:

```
Hamlet says, "Seems," madam! Nay it is; I know not "seems."
```

into 

```
1,"Hamlet says, ""Seems,"" madam! Nay it is; I know not ""seems."""
```


Let's read `shakespeare.csv`. What do you expect?

``` ruby
pp CSV.read( 'shakespeare.csv' )
```

returns

``` ruby
[["1", "Hamlet says, \"Seems,\" madam! Nay it is; I know not \"seems.\""]]
```

That's great. It works. The commas and quotes get escaped.
Now lets try the "unix-style" escaping with backslashes (e.g. `\"` for `""`)
used by PostgreSQL, MySQL and others (when exporting database tables in CSV, for example):

```
1,"Hamlet says, \"Seems,\" madam! Nay it is; I know not \"seems.\""
```

What do you expect? Of course, it crashes.
The CSV standard library has no understanding
of "unix-style" escaping with backslashes
that we use day-in, day-out in ruby.
Why?

> I disagree that it's broken. It's implementing the [strict] RFC [CSV format]
> and gives you the tools that allow you to be less strict.

Oh, I see. It's not in the "standard", that is, it's not written in the one page CSV Request for Comments (RFC) memo. Ha. Ha. Ha. 
That's a good excuse. Thank you.

> Have you read the [strict] RFC 4180 [CSV format memo]? The quoting rules are in there.
 

Okkie. Let's add a space before the quote. Can you see the space?
Can you see the difference?

```
1, "Hamlet says, ""Seems,"" madam! Nay it is; I know not ""seems."""
```

What do you expect?

Yes, it crashes. How are you feeling now? It says:

```
# => #<CSV::MalformedCSVError: Illegal quoting in line 1.>
```

And that's just a start. Try adding a space after the quote.

```
# => #<CSV::MalformedCSVError: Unclosed quoted field on line 1.>
```

SAD. SAD. SAD. Another crash. For more fun let's try:

```
Los Angeles,   34°03'N,    118°15'W
New York City, 40°42'46"N, 74°00'21"W
Paris,         48°51'24"N, 2°21'03"E
```

What do you expect? Yes, of course. A firework of errors.
Welcome to the stray quote hell.


How to fix the strict - dare I say - idiotic and simplistic quoting rules? Any ideas?

Let's look at ruby :-). Trivia Quiz. How many ways to quote a string in ruby? One and only one way and
every single leading and trailing whitespace counts (and will break your code).
Of course, not. That wouldn't make the programmers happy, happy, happy, would it?


Jan Lelis on Idiosyncratic Ruby
documents in [210 Ways to Rome](https://idiosyncratic-ruby.com/15-207-ways-to-rome.html)
not one, not two, not three,
not four, not ten, not twenty, not one hundred but - surprise, surprise -
yes, more than two hundred ways!
That makes programmers happy, happy, happy.

- 1 Double Quoted Literal
- 1 Single Quoted Literal
- 1 Single Char Literals
- 9 Heredocs
- 66 Percent Syntax / Q
- 66 Percent Syntax / q
- 66 Percent Syntax / None


Try to read double AND single quoted literals with
the CSV standard library. Example:

```
1, "Hamlet says, 'Seems,' madam! Nay it is; I know not 'seems.'"
2, 'Hamlet says, "Seems," madam! Nay it is; I know not "seems."'
```

Of course, it's impossible. You can only configure one and only one `quote_char`.
Guess what? The new CSV reader / parser alternative
works out "out-of-the-box" with six quote literal styles. Not yet
reaching the nirvana of ruby but it's a start on the way to happiness :-).
Example:


```
1, "Hamlet says, 'Seems,' madam! Nay it is; I know not 'seems.'"
2, 'Hamlet says, "Seems," madam! Nay it is; I know not "seems."'
3, ‹Hamlet says, "Seems," madam! Nay it is; I know not "seems."›
4, ›Hamlet says, "Seems," madam! Nay it is; I know not "seems."‹
5, «Hamlet says, "Seems," madam! Nay it is; I know not "seems."»
6, »Hamlet says, "Seems," madam! Nay it is; I know not "seems."«
```

What more?
Of course, you can use leading and trailing space before and
after all quotes.
How are you feeling now?



Bonus. Let's fix un-quoted "stray" quote hell with a new rule. Anyone?

```
Los Angeles,   34°03'N,    118°15'W
New York City, 40°42'46"N, 74°00'21"W
Paris,         48°51'24"N, 2°21'03"E
```

NEW! Rule no. 5 -
A quote only "kicks-in" if it's the first (non-whitespace) character of the value
(otherwise it's just a "vanilla" literal character) e.g. `48°51'24"N`
needs no quote :-).  No more "stray" quote errors / exceptions.



## Innovate, Innovate, Innovate -  CSV <3 JSON

Believe it or not? CSV
the world's #1 and most popular data format
is alive and kicking.

What's next for CSV? [CSV <3 JSON](https://github.com/csvspecs/csv-json) and much more.
Stay tuned for the next episode.




## Request for Comments (RFC)

Please post your comments to the [ruby-talk mailing list](https://rubytalk.org) thread. Thanks!
