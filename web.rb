require "sinatra"
require "sinatra/content_for"
require "i18n"
require "i18n/backend/fallbacks"
require "rack"
require "rack/contrib"
require "json"

use Rack::Locale
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.config.enforce_available_locales = false
I18n.backend.load_translations

configure :development, :test do
  require "pry"
  # caching
  require "mini_cache"
  $cache = MiniCache::Store.new
end

configure :production do
  # analytics
  require "newrelic_rpm"
  # caching
  require "dalli"
  raise "MEMCACHEDCLOUD_SERVERS not defined as an environment variable!" if ENV["MEMCACHEDCLOUD_SERVERS"].nil?
  $cache = Dalli::Client.new(ENV["MEMCACHEDCLOUD_SERVERS"].split(','), {
    :username => ENV["MEMCACHEDCLOUD_USERNAME"],
    :password => ENV["MEMCACHEDCLOUD_PASSWORD"]
  })
  module DalliGetOrSet
    def get_or_set(key)
      value = self.get(key)
      return value if value
      value = yield
      self.set(key, value)
      value
    end
  end
  $cache.extend(DalliGetOrSet)
end

require_relative "controllers/index_controller"
require_relative "controllers/story_controller"

# 09:00AM same experience as current site using Crossway API
# 10:00AM add general internationalisation (and add mandarin) http://blog.lingohub.com/developers/2013/08/internationalization-for-ruby-i18n-gem/#i18n-sinatra
# 11:00AM add bibles.org for getting The Message in text for English for novel reading
# 12:00PM add bibles.org mandarin bible
# 03:00PM add uninterrupted viewing mode, where verses references are not shown unless hover on a verse, and it highlights light yellow with its verse showing
# 05:30PM add caching

# 06:30PM add faith by hearing for audio
# 08:00PM share via qzone, and another chinese site + FB, twitter
# -----PM change background color to be an off white, change the font color to less harsh
# -----PM better font?
# -----PM assett pipeline, compress, combine, yada (or just use minify for mac)

# Pitch
# - most people will only remember one or two things, so pitch hard on a couple things in the pitch, not all the features
# - simple, unexpected, concrete, credible (18k), emotional, stories (tell the story)
# - focus on the difference it will make to people
# - explain it simply (einstein)
# - 5 min pitch, but make the pitch in first 2 mins