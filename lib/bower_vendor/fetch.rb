module BowerVendor
  class Fetch < Base
    def execute
      Dir.chdir(work_dir) do
        fork do
          exec "bower install"
        end
        Process.wait
      end
    end
  end
end
