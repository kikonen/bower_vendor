# BowerVendor

Rake tasks to manage vendor assets for rails application
using bower. This gem is inspired by bower-rails.

# Install

Gemfile
```ruby
gem 'bower_vendor'
```

# Usage

1) Configuration file

vendor.yml
```ruby
angular:
  version: 1.3.15
  files:
  - angular.js
```

2) Install assets

```bash
bundle exec rake vendor:all
```

Assets will be copied into vendor/assets
