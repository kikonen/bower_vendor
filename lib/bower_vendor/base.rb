module BowerVendor
  class Base
    def initialize
    end

    def vendors
      @vendors ||= YAML.load_file('vendor.yml')
    end

    def config
      @config ||= load_config('config/bower_vendor.yml')
      @config ||= load_config(File.join(BowerVendor.root_dir, 'config/bower_vendor.yml'))
    end

    def load_config(file)
      if File.exist?(file)
        YAML.load_file(file)
      else
        nil
      end
    end

    def base_src_dir
      @base_src_dir ||= 'bower_components'
    end

    def work_dir
      if defined?(Rails)
        "#{Rails.root}/tmp"
      else
        'tmp'
      end
    end
  end
end
