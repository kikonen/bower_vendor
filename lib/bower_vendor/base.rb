module BowerVendor
  class Base
    def initialize
    end

    def vendors
      @vendors ||= YAML.load_file('vendor.yml')
    end

    def config
#      @config ||= YAML.load_file('vendor_config.yml')
      @config ||= {
        base_dir: 'vendor/assets',
        dst_dirs: {
          'css' => 'stylesheets',
          'js' => 'javascripts',
        }
      }
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
