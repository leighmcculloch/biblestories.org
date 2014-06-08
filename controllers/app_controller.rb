class Web < Sinatra::Application

  # exceptions
  configure :production do
    use Bugsnag::Rack
    enable :raise_errors
  end

  # caching
  configure :development, :test do
    $cache = MiniCache::Store.new
  end
  configure :production do
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
end

require_relative "app_controller_i18n"
require_relative "asset_controller"
require_relative "index_controller"
require_relative "pitch_controller"
require_relative "story_controller"
