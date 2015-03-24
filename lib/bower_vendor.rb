require 'awesome_print'
require 'yaml'
require 'json'

require "bower_vendor/version"
require "bower_vendor/base"
require "bower_vendor/copy"
require "bower_vendor/fetch"
require "bower_vendor/setup"

if defined?(Rails)
  require "bower_vendor/railtie"
end

module BowerVendor
  def self.root_dir
    File.expand_path('../..', __FILE__)
  end

  def self.load_tasks
    dir = File.join(root_dir, 'lib/tasks')
    load "#{dir}/vendor.rake"
  end
end
