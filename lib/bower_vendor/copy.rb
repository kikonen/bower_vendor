module BowerVendor
  class Copy < Base
    def execute
      ap vendors

      vendors.each do |asset_key, asset_data|
        src_dir = "#{base_src_dir}/#{asset_key}"
        puts "processing: #{src_dir}"

        run_scripts(asset_key, asset_data)
        copy_files(asset_key, asset_data)
      end
    end

    def run_scripts(asset_key, asset_data)
      scripts = (asset_data['build'] || [])
      if !scripts.empty?
        puts "  building..."
        scripts.each do |cmd|
          full_cmd ="cd #{src_dir} && #{cmd}"
          puts "    #{full_cmd}"
          pid = fork do
            exec full_cmd
          end
          Process.wait pid
        end
      end
    end

    def copy_files(asset_key, asset_data)
      puts "  copying..."
      version = asset_data['version']
      asset_data['files'].each do |orig_path|
        src_path = orig_path.gsub("{{VERSION}}", version)
        has_version = orig_path != src_path
        src_file = src_path.split('/').last
        ext = src_file.split('.').last
        dst_file = src_file
        unless has_version
#          dst_file = src_file.gsub("\.#{ext}", "-#{version}.#{ext}")
        end

        src_dir = "#{work_dir}/bower_components/#{asset_key}"

        base_dst_dir = dst_dirs[ext]
        dst_dir = "#{base_dst_dir}/#{asset_key}-#{version}"

        full_src_file = "#{src_dir}/#{src_path}"
        full_dst_file = "#{dst_dir}/#{dst_file}"

        puts "    #{full_src_file} => #{full_dst_file}"
        if !File.exist? full_src_file
          raise "NOT_FOUND: #{full_src_file}"
        end
        if !Dir.exist? dst_dir
          FileUtils.mkdir_p dst_dir
        end
        FileUtils.cp full_src_file, full_dst_file
      end
    end

    def dst_dirs
      @dst_dirs ||= setup_dst_dirs
    end

    def setup_dst_dirs
      base_dir = config[:base_dir]
      config[:dst_dirs].map do |k, v|
        [k, "#{base_dir}/#{v}"]
      end.to_h
    end
  end
end
