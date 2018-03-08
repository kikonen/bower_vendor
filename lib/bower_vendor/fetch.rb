class BowerVendor::Fetch < BowerVendor::Base
  def execute
    return if vendors.empty?

    script = executable
    puts "excutable: #{script}"

    Dir.chdir(work_dir) do
      fork do
        exec "#{script} install"
      end
      Process.wait
    end
  end

  def executable
    f = "#{local_node_bin}/bower"
    File.exists?(f) ? f : 'bower'
  end
end
