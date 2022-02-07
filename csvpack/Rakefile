require 'hoe'
require './lib/csvpack/version.rb'

Hoe.spec 'csvpack' do

  self.version = CsvPack::VERSION

  self.summary = "csvpack - tools 'n' scripts for working with tabular data packages using comma-separated values (CSV) datafiles in text with meta info (that is, schema, datatypes, ..) in datapackage.json; download, read into and query CSV datafiles with your SQL database (e.g. SQLite, PostgreSQL, ...) of choice and much more"
  self.description = summary

  self.urls    = ['https://github.com/csv11/csvpack']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['logutils',     '>=0.6.1'],
    ['fetcher',      '>=0.4.5'],
    ['activerecord', '>=5.0.0'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 2.2.2'
  }

end
