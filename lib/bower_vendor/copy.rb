module BowerVendor
  class Copy < Base
    def execute
      vendors.each do |asset_key, asset_data|
        src_dir = "#{base_src_dir}/#{asset_key}"
        msg 0, "processing: #{src_dir}"

        run_scripts(asset_key, asset_data, 1)
        copy_assets(asset_key, asset_data, 1)
      end
    end

    def run_scripts(asset_key, asset_data, level)
      scripts = (asset_data['build'] || [])
      if !scripts.empty?
        msg level, "building..."
        scripts.each do |cmd|
          full_cmd ="cd #{src_dir} && #{cmd}"
          msg level + 1, full_cmd
          pid = fork do
            exec full_cmd
          end
          Process.wait pid
        end
      end
    end

    def copy_assets(asset_key, asset_data, level)
      msg level, "copying: #{asset_key}..."
      copy_asset(asset_key, asset_data, asset_data['assets'], '', level + 1)
    end

    def copy_asset(asset_key, asset_data, assets, target_path = '', level)
      assets.each do |asset|
        if asset.is_a? Hash
          sub_asset = asset.keys.first
          sub_target_path = target_path.empty? ? sub_asset : target_path + '/' + sub_asset
          copy_asset(asset_key, asset_data, asset[sub_asset], sub_target_path, level + 1)
        else
          msg level, asset

          version = asset_data['version'].to_s
          raise "VERSION MISSING: #{asset_data.inspect}" if version.blank?

          src_path = asset.gsub("{{VERSION}}", version)

          base_src_dir = "#{work_dir}/bower_components"
          src = "#{base_src_dir}/#{asset_key}/#{src_path}"

          files = Dir[src].sort!
          raise "NOT_FOUND: #{src}" if files.empty?
          files.each do |src_path|
            copy_src_file asset_key, asset_data, asset, src_path, target_path, level + 1
          end
        end
      end
    end

    def copy_src_file(asset_key, asset_data, orig_path, full_src_file, target_path, level)
      if !File.exist? full_src_file
        raise "NOT_FOUND: #{full_src_file}"
      end

      version = asset_data['version'].to_s
      src_file = full_src_file.split('/').last
      ext = src_file.split('.').last
      dst_file = src_file

      base_dst_dir = dst_dirs[ext]
      raise "NOT_FOUND_EXT: #{ext}" unless base_dst_dir

      dst_dir = "#{base_dst_dir}/#{asset_key}-#{version}"
      dst_dir = "#{dst_dir}/#{target_path}" unless target_path.empty?
      full_dst_file = "#{dst_dir}/#{dst_file}"

      msg level, "#{full_src_file} => #{full_dst_file}"
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
end
