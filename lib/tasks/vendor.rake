task :vendor do
  desc 'vendor'
  require 'awesome_print'

  data = YAML.load_file('vendor.yml')
  ap config: data

  bower_data = JSON.parse(IO.read('vendor/assets/bower.json'))
  versions = bower_data['dependencies']
  ap versions: versions

  base_src_dir = 'vendor/assets/bower_components'
  dst_dirs = {
    'css' => 'vendor/assets/stylesheets',
    'js' => 'vendor/assets/javascripts'
  }

  data.each do |asset_key, asset_data|
    version = versions[asset_key]
    src_dir = "#{base_src_dir}/#{asset_key}"
    puts "processing: #{src_dir}"

    scripts = (asset_data['build'] || [])
    if scripts.present?
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

    puts "  copying..."
    asset_data['files'].each do |orig_path|
      src_path = orig_path.gsub("{{VERSION}}", version)
      has_version = orig_path != src_path
      src_file = src_path.split('/').last
      ext = src_file.split('.').last
      dst_file = src_file
      unless has_version
        dst_file = src_file.gsub("\.#{ext}", "-#{version}.#{ext}")
      end

      base_dst_dir = dst_dirs[ext]
      dst_dir = "#{base_dst_dir}/#{asset_key}"

      full_src_file = "#{src_dir}/#{src_path}"
      full_dst_file = "#{dst_dir}/#{dst_file}"

      puts "    #{full_src_file} => #{full_dst_file}"
      if !File.exist? full_src_file
        raise "NOT_FOUND: #{full_src_file}"
      end
      if !Dir.exist? dst_dir
        FileUtils.mkdir dst_dir
      end
      FileUtils.cp full_src_file, full_dst_file
    end
  end
end
