require 'fileutils'
require 'tempfile'
require 'uki/include_js'

module Uki
  
  class Builder

    attr_accessor :path
    attr_accessor :options

    def initialize(path, options = {})
      @path = path
      @options = options
    end

    def code
      options[:compress] ? compressed_code : plain_code
    end

    def minified_css
      compiled_css @path
    end

  protected
    def compressed_code
      unless @compressed_code
        code = Uki.include_js(path) do |path|
          if path.match(/.css$/)
            compiled_css path
          else
            File.read(path)
          end
        end
        Tempfile.open('w') { |file|
          file.write(code)
          file.flush
          @compressed_code = compiled_js(file.path)
        }
      end
      @compressed_code
    end

    def plain_code
      @plain_code ||= Uki.include_js path
    end

    def compiled_css path
      system "java -jar #{path_to_yui_compressor} #{path} > #{path}.tmp"
      code = File.read("#{path}.tmp")
      FileUtils.rm "#{path}.tmp"
      code
    end

    def compiled_js path
      if options[:compressor] == :closure
        system "/usr/local/bin/uki_closure_compressor #{path} #{path}.tmp"
      elsif options[:compressor] == :yui
        system "/usr/local/bin/uki_yui_compressor #{path} #{path}.tmp"
      elsif options[:compressor] == :uglifyjs
        system "/usr/local/bin/uki_uglifyjs_compressor #{path} #{path}.tmp"
      else
        system "/usr/local/bin/uki_uglifyjs_compressor_fast #{path} #{path}.tmp"
      end
      if options[:indent]
        system "/usr/local/bin/uki_jsbeautify_indent #{path}.tmp #{path}.indent"
        code = File.read("#{path}.indent")
      else
        code = File.read("#{path}.tmp")
      end
      FileUtils.rm "#{path}.tmp"
      code
    end

    def path_to_google_compiler
      File.join(UKI_ROOT, 'java', 'compiler.jar')
    end

    def path_to_yui_compressor
      File.join(UKI_ROOT, 'java', 'yuicompressor.jar')
    end
  end  
  
end
