# encoding: utf-8

module CsvPack

class Downloader

  def initialize( cache_dir='./pack' )
    @cache_dir = cache_dir   # todo: check if folder exists now (or on demand)?
    @worker = Fetcher::Worker.new
  end

  SHORTCUTS = {
    ## to be done
  }

  def fetch( name_or_shortcut_or_url )   ## todo/check: use (re)name to get/update/etc. why? why not??

    name = name_or_shortcut_or_url

    ##
    ## e.g. try
    ##   country-list
    ##

    ## url_base = "http://data.okfn.org/data/core/#{name}"
    ## url_base = "https://datahub.io/core/#{name}"

    ## or use "https://github.com/datasets/#{name}/raw/master"
    url_base = "https://raw.githubusercontent.com/datasets/#{name}/master"


    url = "#{url_base}/datapackage.json"

    dest_dir = "#{@cache_dir}/#{name}"
    FileUtils.mkdir_p( dest_dir )

    pack_path = "#{dest_dir}/datapackage.json"   ## todo/fix: rename to meta_path - why? why not?
    @worker.copy( url, pack_path )

    h = Meta.load_file( pack_path )
    pp h

    ## copy resources (tables)
    h.resources.each do |r|
      puts "== resource:"
      pp r

      res_name          = r['name']
      res_relative_path = r['path']   ## fix/todo: might no contain the url - is now res_url_or_relative_path !!!!!
      if res_relative_path.nil?
        res_relative_path = "#{res_name}.csv"
      end

      res_url       = r['url']   ## check - old package format - url NO longer used!!!!
      if res_url.nil?
         ## build url
         res_url = "#{url_base}/#{res_relative_path}"
      end

      ## todo/fix: rename - use just res_path - why? why not?
      local_res_path = "#{dest_dir}/#{res_relative_path}"
      puts "[debug] local_res_path: >#{local_res_path}<"
      local_res_dir   = File.dirname( local_res_path )
      FileUtils.mkdir_p( local_res_dir )

      @worker.copy( res_url, local_res_path )
    end
  end

end # class Downloader

end # module CsvPack
