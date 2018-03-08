# BowerVendor

Simple rake tasks to manage vendor assets for rails application
using bower or yarn. This gem is inspired by bower-rails.

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

github Syntax
```ruby
# git & tag for the cases when bower central repo doesn't
# have some package registered
bootstrap-multiselect:
  version: X.Y.Z
  git: git@github.com:gituser/repo-path.git
  tag: <git-tag>
  assets:
  - <asset-pattern>
  - <asset-path>:
    - <asset pattern>
```

URL Syntax
```ruby
bootstrap-multiselect:
  version: X.Y.Z
  url: https://some.host/some.js
```


vendor.yml
```ruby
jquery:
  version: 2.1.3
  assets:
  - dist/jquery.js
jquery-ujs:
  version: 1.0.3
  assets:
  - src/rails.js
lodash:
  version: 3.0.0
  assets:
  - lodash.js
angular:
  version: 1.3.15
  assets:
  - angular.js
bootstrap-sass:
  version: 3.3.4
  assets:
  - assets/javascripts/bootstrap-sprockets.js
  # copy into "bootstrap" subdir in destination
  - bootstrap:
    - assets/javascripts/*.js
  - assets/stylesheets/_bootstrap.scss
  - assets/stylesheets/_bootstrap-sprockets.scss
  - bootstrap:
    - assets/stylesheets/bootstrap/*.scss
      # copy into "bootstrap/mixins" subdir in destination
    - mixins:
      - assets/stylesheets/bootstrap/mixins/*.scss
  # "*" matches all files
  - assets/fonts/bootstrap/*
bootstrap-multiselect:
  version: 0.9.13
  git: git@github.com:davidstutz/bootstrap-multiselect.git
  tag: v0.9.13
  assets:
  - dist/css/bootstrap-multiselect.css
  - dist/js/bootstrap-multiselect.js
  - dist/js/bootstrap-multiselect-collapsible-groups.js
```

vendor_yarn.yml
```yaml
bootstrap:
  assets:
    - scss/*.scss
    - mixins:
        - scss/mixins/*.scss
    - utilities:
        - scss/utilities/*.scss
    - js/dist/*.js

jquery:
  assets:
    - dist/jquery.js

lodash:
  assets:
    - lodash.js

url.js:
  assets:
    - url.js

vue:
  assets:
    - dist/vue.js
```

2) Install assets

```bash
bundle exec rake vendor:clean
bundle exec rake vendor:all
```

Assets will be copied into vendor/assets

3) Using in application

Instructions for bootstrap-sass are shown in https://github.com/twbs/bootstrap-sass

app/assets/stylesheets/import_bootstrap.scss
````css
$icon-font-path: "bootstrap-sass-3.3.4/";
@import "bootstrap-sass-3.3.4/bootstrap-sprockets";
@import "bootstrap-sass-3.3.4/bootstrap";
```

app/assets/javascripts/application.js
````javascript
//
//= require jquery-2.1.3/jquery
//= require jquery-ujs-1.0.3/rails
//= require lodash-3.0.0/lodash
//= require bootstrap-sass-3.3.4/bootstrap-sprockets
//
//= require angular-1.3.15/angular
//
```

4) Check for asset updates

```bash
bundle exec rake vendor:check
```


# TODO

- Improve documentation
- Fix SVG image vs. font issue
