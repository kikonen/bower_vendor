# BowerVendor

Simple rake tasks to manage vendor assets for rails application
using bower. This gem is inspired by bower-rails.

Reason for the existence of this gem is to have improved assets control, which is lacking
in bower-rails. This gem not only fetches assets using bower, but also contains logic to
maintain actually used assets in "vendor/asests" so that they can be committed safely into
repository.

This has various benefits
- Removes bower dependency from deploy
  * Safe-guarding deplpy from unavailability of bower central repository
  * Faster deploy
  * no need to have node/bower/etc. installed in deployed machine
- Versioned assets, allowing safer upgrading of them (and safe rollback to old versions)
  * This allows that not all parts of the application (or engines) are requierd to be upgraded
    to latest vendor asset versions at once
- Assets are available always
  * Just clone repository and it's ready to use

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
