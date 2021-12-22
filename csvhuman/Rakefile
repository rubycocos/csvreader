require 'hoe'
require './lib/csvhuman/version.rb'

Hoe.spec 'csvhuman' do

  self.version = CsvHuman::VERSION

  self.summary = "csvhuman - read tabular data in the CSV Humanitarian eXchange Language (HXL)  format, that is, comma-separated values (CSV) line-by-line records with a hashtag (meta data) line using the Humanitarian eXchange Language (HXL) rules"
  self.description = summary

  self.urls    = ['https://github.com/csvreader/csvhuman']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
     ['csvreader',  '>=1.2.1']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 2.2.2'
  }

end
