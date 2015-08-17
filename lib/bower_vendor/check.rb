module BowerVendor
  class Check < Base
    def execute
      Dir.chdir(work_dir) do
        fork do
          exec "bcu"
        end
        Process.wait
      end
    end
  end
end
