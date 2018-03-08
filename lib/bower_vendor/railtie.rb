class BowerVendor::Railtie < Rails::Railtie
  rake_tasks do
    BowerVendor.load_tasks
  end
end
