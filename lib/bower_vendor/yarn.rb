class BowerVendor::Yarn < BowerVendor::Copy
  def full_asset_key_src_dir(asset_key)
    "node_modules/#{asset_key}"
  end

  def validate_vendors
    # nothing
  end

  def load_vendors
    versions = load_vendor_versions

    vendors = YAML.load_file 'vendor_yarn.yml'

    vendors.each do |vendor, vendor_data|
      version = versions[vendor]
      raise "YARN: missing vendor: #{vendor}" unless version
      vendor_data['version'] = version
    end

    vendors
  end

  def load_vendor_versions
    data = File.read 'yarn.lock'
    lines = data.split("\n")

    versions = {}

    vendor = nil
    lines.each do |line|
      next if line.start_with?('#')
      if line.start_with?('  version')
        version = line.split(' ').last.tr('"', '')
        versions[vendor] = version
        vendor = nil
      elsif line.start_with?(' ')
        next
      else
        vendor = line.split('@').first
      end
    end

    versions
  end
end
