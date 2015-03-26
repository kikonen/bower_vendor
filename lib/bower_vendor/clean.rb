module BowerVendor
  class Clean < Base
    def initialize
    end

    def execute
      FileUtils.rm_rf "#{work_dir}/bower_components"
      FileUtils.rm_f "#{work_dir}/bower.json"
    end
  end
end
