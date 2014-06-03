Bundler.require :default, ENV['RACK_ENV']

class Web < Sinatra::Application
  set :root, File.dirname(__FILE__)

  # assets
  register Sinatra::AssetPack
  assets {
    serve "/js",     from: "assets/js"
    serve "/css",    from: "assets/css"
    serve "/images", from: "assets/images"

    js :web, "/js/web.js", [
        "/js/**/*.js"
    ]

    css :web, "/css/web.css", [
        "/css/**/*.css"
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
  }

  # localization
  use Rack::Locale
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.config.enforce_available_locales = false
  I18n.backend.load_translations
  before do
    case request.host
      when "greatstoriesofthebible.cn", "www.greatstoriesofthebible.cn"
        I18n.locale = :zh
    end
  end

  # exceptions
  configure :production, :staging do
    use Bugsnag::Rack
    enable :raise_errors
  end

  # caching
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

require_relative "controllers/index_controller"
require_relative "controllers/pitch_controller"
require_relative "controllers/story_controller"
