class BowerVendor::Clean < BowerVendor::Base
  def initialize
  end

  def execute
    FileUtils.rm_rf "#{work_dir}/bower_components"
    FileUtils.rm_f "#{work_dir}/bower.json"
  end
end
