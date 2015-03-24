module BowerVendor
  class Setup < Base
    def execute
      create_bowerrc
      create_bower_json
    end

    def create_bower_json
      data = {
        name: 'autogenerated',
        dependencies: {
        },
        resolutions: {
        },
      }
      vendors.each do |vendor_key, vendor|
        data[:dependencies][vendor_key] = vendor['version']
        data[:resolutions][vendor_key] = vendor['version']
      end
      File.write("#{work_dir}/bower.json", JSON.pretty_generate(data))
    end

    def create_bowerrc
      data = {
        directory: "bower_components"
      }
      File.write("#{work_dir}/.bowerrc", JSON.pretty_generate(data))
    end
  end
end
