source "https://rubygems.org"

ruby "2.0.0"

gem "unicorn"
gem "sinatra"
gem "sinatra-contrib"
gem "httparty"
gem "i18n"
gem "rack-contrib"
gem "json"

group :development, :test do
  gem "debugger-ruby_core_source"
  gem "pry"
  gem "pry-debugger"
  gem "rerun"
  gem "mini_cache"
end

group :production do
  gem "dalli"
end

gem 'newrelic_rpm'
