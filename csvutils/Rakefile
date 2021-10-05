require 'hoe'
require './lib/csvutils/version.rb'

Hoe.spec 'csvutils' do

  self.version = CsvUtils::VERSION

  self.summary = "csvutils - tools 'n' scripts for working with comma-separated values (csv) datafiles - the world's most popular tabular data interchange format in text"
  self.description = summary

  self.urls = ['https://github.com/csvreader/csvutils']

  self.author = 'Gerald Bauer'
  self.email = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
     ['csvreader',  '>=1.2.3']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 2.2.2'
  }

end
