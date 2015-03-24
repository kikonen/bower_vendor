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
  - angular-csp.css
```

2) Install assets

```bash
bundle exec rake vendor:all
```

Assets will be copied into vendor/assets


# TODO

- Support other more asset types
  * curently only js and css are supported
  * should support also fonts, etc.
- Support more complex paths for assets
