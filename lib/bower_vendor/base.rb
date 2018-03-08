class BowerVendor::Base
  def initialize
  end

  def vendors
    @vendors ||= load_vendors.delete_if { |vendor, vendor_data| !accept_vendor?(vendor, vendor_data) }
    validate_vendors(@vendors)
    @vendors
  end

  def accept_vendor?(vendor, vendor_data)
    !vendor_data['yarn']
  end

  def validate_vendors(vendors)
    # validate resources
    vendors.each do |vendor_key, vendor|
      raise "VERSION MISSING: #{vendor_key}: #{vendor.inspect}" unless vendor['version']
      puts "WARN: ASSETS MISSING: #{vendor_key}: #{vendor.inspect}" unless vendor['assets']
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

  def full_vendor_src_dir(vendor)
    "#{self.work_dir}/bower_components/#{vendor}"
  end

  def work_dir
    "#{self.root_dir}/tmp"
  end

  def local_node_bin
    "#{self.root_dir}/node_modules/.bin"
  end

  def root_dir
    @root_dir ||= if defined?(Rails)
                    Rails.root
                  else
                    Dir.pwd
                  end
  end

  def load_vendors
    vendors = YAML.load_file('vendor.yml')
    vendors.sort do |a, b|
      a[0] <=> b[0]
    end.to_h
  end
end
