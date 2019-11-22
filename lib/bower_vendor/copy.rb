class BowerVendor::Copy < BowerVendor::Base
  def execute
    vendors.each do |vendor, asset_data|
      src_dir = full_vendor_src_dir(vendor)
      msg 0, "processing: #{src_dir}"

      run_build_scripts(vendor, asset_data, 1)
      copy_assets(vendor, asset_data, 1)
    end
  end

  def run_build_scripts(vendor, asset_data, level)
    scripts = (asset_data['build'] || [])
    return if scripts.empty?

    src_dir = full_vendor_src_dir(vendor)

    msg level, "building..."
    scripts.each do |cmd|
      msg level + 1, "cd #{src_dir} && #{cmd}"

      pid = fork do
        Dir.chdir src_dir
        puts `#{cmd}`
      end
      Process.wait pid
    end
  end

  def copy_assets(vendor, asset_data, level)
    msg level, "copying: #{vendor}..."
    copy_asset(vendor, asset_data, asset_data['assets'], '', level + 1)
  end

  def copy_asset(vendor, asset_data, assets, target_path = '', level)
    assets ||= []
    if assets.empty?
      msg level, "WARN: ASSETS MISSING"
    end

    assets.each do |asset|
      if asset.is_a? Hash
        sub_asset = asset.keys.first
        sub_target_path = target_path.empty? ? sub_asset : target_path + '/' + sub_asset
        copy_asset(vendor, asset_data, asset[sub_asset], sub_target_path, level + 1)
      else
        msg level, asset

        version = asset_data['version'].to_s
        raise "VERSION MISSING: #{asset_data.inspect}" if version.empty?

        asset_path = asset.gsub("{{VERSION}}", version)
        src = "#{full_vendor_src_dir(vendor)}/#{asset_path}"

        files = Dir[src].sort!
        raise "NOT_FOUND: #{src}" if files.empty?
        files.each do |src_path|
          copy_src_file vendor, asset_data, asset, src_path, target_path, level + 1
        end
      end
    end
  end

  def copy_src_file(vendor, asset_data, orig_path, full_src_file, target_path, level)
    if !File.exist? full_src_file
      raise "NOT_FOUND: #{full_src_file}"
    end

    version = asset_data['version'].to_s
    src_file = full_src_file.split('/').last
    ext = src_file.split('.').last
    dst_file = src_file

    base_dst_dir = self.dst_dirs[ext]
    raise "NOT_FOUND_EXT: #{ext}" unless base_dst_dir

    dst_dir = "#{base_dst_dir}/#{vendor}-#{version}"
    dst_dir = "#{dst_dir}/#{target_path}" unless target_path.empty?
    full_dst_file = "#{dst_dir}/#{dst_file}"

    msg level, "#{full_src_file} => #{full_dst_file}"

    # NOTE KI create symlink to "current" version
    vendor_parsed_path = vendor.split('/')
    Dir.chdir(File.join(base_dst_dir, vendor_parsed_path[0, vendor_parsed_path.length - 1])) do
      vendor_versioned_dir = vendor_parsed_path.last
      FileUtils.rm_f(vendor_versioned_dir)
      FileUtils.ln_sf("#{vendor_versioned_dir}-#{version}", vendor_versioned_dir)
    end

    if !Dir.exist? dst_dir
      FileUtils.mkdir_p dst_dir
    end
    FileUtils.cp full_src_file, full_dst_file
  end

  def dst_dirs
    @dst_dirs ||= setup_dst_dirs
  end

  def setup_dst_dirs
    base_dir = config['base_dir']
    config['dst_dirs'].map do |k, v|
      [k, "#{base_dir}/#{v}"]
    end.to_h
  end

  def msg(level, msg)
    puts "#{'  ' * level}#{msg}"
  end
end
