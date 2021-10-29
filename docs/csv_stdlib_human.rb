# encoding: utf-8

require 'csv'
require 'pp'


txt = <<TXT
#######
# try with some comments
#   and blank lines even before header (first row)

Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%

Bayerische Staatsbrauerei Weihenstephan,  Freising,  Hefe Weissbier,   5.4%
Brauerei Spezial,                         Bamberg,   Rauchbier Märzen, 5.1%
Hacker-Pschorr Bräu,                      München,   Münchner Dunkel,  5.0%
Staatliches Hofbräuhaus München,          München,   Hofbräu Oktoberfestbier, 6.3%
TXT


COMMENTS_REGEX = /^\s*#/
BLANK_REGEX    = /^\s*$/   ## skip all whitespace lines - note: use "" for a blank record
SKIP_REGEX = Regexp.union( COMMENTS_REGEX, BLANK_REGEX )

##  register our own converters
CSV::Converters[:strip] = ->(field) { field.strip }

csv_opts = {
  skip_lines:  SKIP_REGEX,
  skip_blanks: true,    ## note: skips lines with no whitespaces only!! (e.g. line with space is NOT blank!!)
  :converters => [:strip],
  encoding: 'utf-8'
}

pp CSV.parse( txt, csv_opts )

# => [["Brewery", "City", "Name", "Abv"],
#     ["Andechser Klosterbrauerei", "Andechs", "Doppelbock Dunkel", "7%"],
#     ["Augustiner Br\u00E4u M\u00FCnchen", "M\u00FCnchen", "Edelstoff", "5.6%"],
#     ["Bayerische Staatsbrauerei Weihenstephan", "Freising", "Hefe Weissbier", "5.4%"],
#     ["Brauerei Spezial", "Bamberg", "Rauchbier M\u00E4rzen", "5.1%"],
#     ["Hacker-Pschorr Br\u00E4u", "M\u00FCnchen", "M\u00FCnchner Dunkel", "5.0%"],
#     ["Staatliches Hofbr\u00E4uhaus M\u00FCnchen", "M\u00FCnchen", "Hofbr\u00E4u Oktoberfestbier", "6.3%"]]
