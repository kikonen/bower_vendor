module BowerVendor
  class Check < Base
    def execute
      Dir.chdir(work_dir) do
        script = executable
        puts "excutable: #{script}"
        fork do
          exec "#{script}"
        end
        Process.wait
      end
    end

    def executable
      f = "#{local_node_bin}/bcu"
      puts "BCU: #{f}"
      File.exists?(f) ? f : 'bcu'
    end
  end
end
