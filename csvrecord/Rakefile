require 'hoe'
require './lib/csvrecord/version.rb'

Hoe.spec 'csvrecord' do

  self.version = CsvRecord::VERSION

  self.summary = "csvrecord - read in comma-separated values (csv) records with typed structs / schemas"
  self.description = summary

  self.urls = ['https://github.com/csvreader/csvrecord']

  self.author = 'Gerald Bauer'
  self.email = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
     ['record',     '>=1.2.0'],
     ['csvreader',  '>=1.1.4']
   ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 2.2.2'
  }

end
