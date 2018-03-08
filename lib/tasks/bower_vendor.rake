namespace :vendor do
  desc 'Do everything except clean'
  task :all => [:setup, :fetch, :copy, :yarn] do
  end

  desc 'Clear bower setup and fetched bower_components'
  task :clean do
    BowerVendor::Clean.new.execute
  end

  desc 'Create setup for bower'
  task :setup do
    BowerVendor::Setup.new.execute
  end

  desc 'Check for asset updates for bower_components (requires bower-check-updates)'
  task :check => [:setup] do
    BowerVendor::Check.new.execute
  end

  desc 'Fetch bower_components'
  task :fetch => [:setup] do
    BowerVendor::Fetch.new.execute
  end

  desc 'Copy bower_components to vendor/assets'
  task :copy do
    BowerVendor::Copy.new.execute
  end

  desc 'Copy yarn node_modules to vendor/assets'
  task :yarn do
    BowerVendor::Yarn.new.execute
  end
end
