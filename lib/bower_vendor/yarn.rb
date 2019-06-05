class BowerVendor::Yarn < BowerVendor::Copy
  def full_vendor_src_dir(vendor)
    "node_modules/#{vendor}"
  end

  def accept_vendor?(vendor, vendor_data)
    vendor_data['yarn']
  end

  def load_vendors
    versions = load_vendor_versions

    vendors_data = YAML.load_file 'vendor.yml'
    vendors_data.delete_if { |vendor, vendor_data| !accept_vendor?(vendor, vendor_data) }

    vendors_data.each do |vendor, vendor_data|
      version = versions[vendor]
      raise "YARN: missing vendor: #{vendor}" unless version
      vendor_data['version'] = version
    end

    vendors_data
  end

  def load_vendor_versions
    puts "RESOLVE yarn vendor versions"
    data = File.read 'yarn.lock'
    lines = data.split("\n")

    versions = {}

    vendors = []

    vendor = nil
    lines.each do |line|
      next if line.start_with?('#')
      next if line.empty?

      if line.start_with?('  version')
        version = line.split(' ').last.tr('"', '')
        versions[vendor] = version
        vendor = nil
      elsif line.start_with?(' ')
        next
      else
        line = line.tr('"', '')
        vendor = line.split('@').select { |e| !e.empty? }.first
        vendor = "@#{vendor}" if line.start_with?('@')
        vendors << vendor
      end
    end

    vendors.each do |vendor|
      package_file_path = "node_modules/#{vendor}/package.json"
      if File.exists?(package_file_path)
        json = File.read(package_file_path)
        data = JSON.parse(json)
        version = data['version']

        if versions[vendor] != version
          puts "CORRECTED: #{vendor} => #{version} (was: #{versions[vendor]})"
          versions[vendor] = version
        end
      else
        puts "NOT_FOUND: #{vendor} => ??? (was: #{versions[vendor]})"
      end
    end

    versions
  end
end
