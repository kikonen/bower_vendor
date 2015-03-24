namespace :vendor do
  desc 'Do all'
  task :all => [:setup, :fetch, :copy] do
  end

  desc 'Clear bower setup and fetched bower_components'
  task :clean do
    BowerVendor::Clean.new.execute
  end

  desc 'Create setup for bower'
  task :setup do
    BowerVendor::Setup.new.execute
  end

  desc 'Fetch bower_components'
  task :fetch do
    BowerVendor::Fetch.new.execute
  end

  desc 'Copy bower_components to vendor/assets'
  task :copy do
    BowerVendor::Copy.new.execute
  end
end
