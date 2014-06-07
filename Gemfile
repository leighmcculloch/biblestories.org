source "https://rubygems.org"

ruby "2.0.0"

gem "unicorn"
gem "sinatra"
gem "sinatra-contrib"
gem "sinatra-assetpack", :require => "sinatra/assetpack"
gem "httparty"
gem "i18n"
gem "rack-contrib"
gem "json"
gem "sanitize"

group :development, :test do
  gem "debugger-ruby_core_source"
  gem "pry"
  gem "pry-debugger"
  gem "rerun"
  gem "mini_cache"
end

group :production do
  gem "dalli"
  gem "bugsnag"
  gem "newrelic_rpm"
end
