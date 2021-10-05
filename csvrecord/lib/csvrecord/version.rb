# encoding: utf-8


module CsvRecord

  module Version
    MAJOR = 0
    MINOR = 4
    PATCH = 3
  end
  VERSION = [Version::MAJOR,
             Version::MINOR,
             Version::PATCH].join('.')


  def self.version
    VERSION
  end

  def self.banner
    "csvrecord/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end

end # module CsvRecord
