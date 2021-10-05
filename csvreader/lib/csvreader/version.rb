
class CsvReader   ## note: uses a class for now - change to module - why? why not?

  module Version
    MAJOR = 1    ## todo: namespace inside version or something - why? why not??
    MINOR = 2
    PATCH = 5

    ## self.to_s  - why? why not?
  end

  VERSION = [Version::MAJOR,
             Version::MINOR,
             Version::PATCH].join('.')

  def self.version   ## keep (as an alternative to VERSION) - why? why not?
    VERSION
  end



  def self.banner
    "csvreader/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end

end # class CsvReader
