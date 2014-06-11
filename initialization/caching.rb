class Web < Sinatra::Application

  configure :development, :test do
    $cache = MiniCache::Store.new
  end

  configure :production, :staging do
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
