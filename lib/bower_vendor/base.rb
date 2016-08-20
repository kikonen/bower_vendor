module BowerVendor
  class Base
    def initialize
    end

    def vendors
      @vendors ||= YAML.load_file('vendor.yml')
      validate_vendors
      @vendors
    end

    def validate_vendors
      # validate resources
      @vendors.each do |vendor_key, vendor|
        raise "VERSION MISSING: #{vendor.inspect}" unless vendor['version']
        raise "ASSETS MISSING: #{vendor.inspect}" unless vendor['assets']
      end
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

    def local_node_bin
      "#{Rails.root}/node_modules/.bin"
    end
  end
end
