# encoding: utf-8


## note: for now CsvUtils is a class!!! NOT a module - change - why? why not?
class CsvUtils

  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 3
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "csvutils/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end

end # class CsvUtils
