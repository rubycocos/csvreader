
class CsvFile



  def self.open(filename, mode="r", **options)
      # wrap a File opened with the remaining +args+ with no newline
      # decorator
      file_opts = {universal_newline: false}.merge(options)

      begin
        f = File.open(filename, mode, file_opts)
      rescue ArgumentError => e
        raise unless /needs binmode/.match?(e.message) and mode == "r"
        mode = "rb"
        file_opts = {encoding: Encoding.default_external}.merge(file_opts)
        retry
      end
      begin
        csv = new(f, options)
      rescue Exception
        f.close
        raise
      end

      # handle blocks like Ruby's open(), not like the CSV library
      if block_given?
        begin
          yield csv
        ensure
          csv.close
        end
      else
        csv
      end
    end


    def self.read(path, *options)
        open(path, *options) { |csv| csv.read }
    end


    def self.parse(*args, &block)
        csv = new(*args)

        return csv.each(&block) if block_given?

        # slurp contents, if no block is given
        begin
          csv.read
        ensure
          csv.close
        end
      end

      def initialize(data, col_sep: ",", row_sep: :auto, quote_char: '"', field_size_limit:   nil,
                       converters: nil, unconverted_fields: nil, headers: false, return_headers: false,
                       write_headers: nil, header_converters: nil, skip_blanks: false, force_quotes: false,
                       skip_lines: nil, liberal_parsing: false, internal_encoding: nil, external_encoding: nil, encoding: nil,
                       nil_value: nil,
                       empty_value: "")
          raise ArgumentError.new("Cannot parse nil as CSV") if data.nil?

          # create the IO object we will read from
          @io = data.is_a?(String) ? StringIO.new(data) : data
          @prefix_io = nil  # cache for input data possibly read by init_separators
          @encoding = determine_encoding(encoding, internal_encoding)
          #
          # prepare for building safe regular expressions in the target encoding,
          # if we can transcode the needed characters
          #
          @re_esc   = "\\".encode(@encoding).freeze rescue ""
          @re_chars = /#{%"[-\\]\\[\\.^$?*+{}()|# \r\n\t\f\v]".encode(@encoding)}/
          @unconverted_fields = unconverted_fields

          # Stores header row settings and loads header converters, if needed.
          @use_headers    = headers
          @return_headers = return_headers
          @write_headers  = write_headers

          # headers must be delayed until shift(), in case they need a row of content
          @headers = nil

          @nil_value = nil_value
          @empty_value = empty_value
          @empty_value_is_empty_string = (empty_value == "")

          init_separators(col_sep, row_sep, quote_char, force_quotes)
          init_parsers(skip_blanks, field_size_limit, liberal_parsing)
          init_converters(converters, :@converters, :convert)
          init_converters(header_converters, :@header_converters, :header_convert)
          init_comments(skip_lines)

          @force_encoding = !!encoding

          # track our own lineno since IO gets confused about line-ends is CSV fields
          @lineno = 0

          # make sure headers have been assigned
          if header_row? and [Array, String].include? @use_headers.class and @write_headers
            parse_headers  # won't read data for Array or String
            self << @headers
          end
        end

        ### IO and StringIO Delegation ###

          extend Forwardable
          def_delegators :@io, :binmode, :binmode?, :close, :close_read, :close_write,
                               :closed?, :eof, :eof?, :external_encoding, :fcntl,
                               :fileno, :flock, :flush, :fsync, :internal_encoding,
                               :ioctl, :isatty, :path, :pid, :pos, :pos=, :reopen,
                               :seek, :stat, :string, :sync, :sync=, :tell, :to_i,
                               :to_io, :truncate, :tty?


        include Enumerable

        def each
            if block_given?
              while row = shift
                yield row
              end
            else
              to_enum
            end
          end

          def read
              rows = to_a
              if @use_headers
                Table.new(rows)
              else
                rows
              end
            end


end
