require 'lib/stories'
require 'lib/story'

DEV = !ENV["DEV"].nil?

LANGS = [:en] #, :"zh-Hans"]
LANG = ENV["LANG"].to_sym || :en

config[:base_zones] = {
  :en => "greatstories.org",
  :"zh-Hans" => "greatstories.cn"
}
config[:base_hosts] = Hash[config[:base_zones].map { |lang, zone| [lang, "#{DEV ? "dev." : ""}#{zone}"] }]
config[:base_urls] = Hash[config[:base_hosts].map { |lang, host| [lang, "http://#{host}"] }]

config[:base_zone] = config[:base_zones][LANG]
config[:base_host] = config[:base_hosts][LANG]
config[:base_url] = config[:base_urls][LANG]

$cache = FileCache.new("api-cache", "caches")
module GetOrSet
  def get_or_set(key)
    value = self.get(key)
    return value if value
    value = yield
    self.set(key, value)
    value
  end
end
$cache.extend(GetOrSet)

compass_config do |config|
  config.output_style = :compressed
end

configure :development do
  activate :livereload
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :directory_indexes

activate :i18n, :langs => LANGS

ignore 'story.html'
after_configuration do
  LANGS.each do |lang|
    prefix = lang.to_s if lang != :en

    page "#{prefix}/index.html", :locale => lang

    Stories.all.each do |story_short_url, story|
      page "#{prefix}/#{story_short_url}.html", :proxy => "/story.html", :locals => { :story => story, :stories => Stories.all }, :locale => lang, :ignore => true
    end
  end
end

activate :autoprefixer do |config|
  config.browsers = ['> 0.1%', 'last 2 versions', 'Explorer >= 6']
  config.cascade  = false
  config.inline   = true
end

configure :build do
  # activate :minify_html
  # activate :minify_css
  # activate :minify_javascript
  activate :gzip
  activate :asset_hash, :ignore => [/^(images|fonts)\//]
  activate :relative_assets
  activate :favicon_maker, :icons => {
    "_favicon.png" => [
      # { icon: "apple-touch-icon-152x152-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS7.
      # { icon: "apple-touch-icon-144x144-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS6 or prior.
      # { icon: "apple-touch-icon-120x120-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS7.
      # { icon: "apple-touch-icon-114x114-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS6 or prior.
      # { icon: "apple-touch-icon-76x76-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS7.
      # { icon: "apple-touch-icon-72x72-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS6 or prior.
      # { icon: "apple-touch-icon-60x60-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPhone with iOS7.
      # { icon: "apple-touch-icon-57x57-precomposed.png" },               # iPhone and iPad users can turn web pages into icons on their home screen. Such link appears as a regular iOS native application. When this happens, the device looks for a specific picture. The 57x57 resolution is convenient for non-retina iPhone with iOS6 or prior. Learn more in Apple docs.
      # { icon: "apple-touch-icon-precomposed.png", size: "57x57" },      # Same as apple-touch-icon.png, expect that is already have rounded corners (but neither drop shadow nor gloss effect).
      # { icon: "apple-touch-icon.png", size: "57x57" },                  # Same as apple-touch-icon-57x57.png, for "default" requests, as some devices may look for this specific file. This picture may save some 404 errors in your HTTP logs. See Apple docs
      # { icon: "favicon-196x196.png" },                                  # For Android Chrome M31+.
      # { icon: "favicon-160x160.png" },                                  # For Opera Speed Dial (up to Opera 12; this icon is deprecated starting from Opera 15), although the optimal icon is not square but rather 256x160. If Opera is a major platform for you, you should create this icon yourself.
      # { icon: "favicon-96x96.png" },                                    # For Google TV.
      # { icon: "favicon-32x32.png" },                                    # For Safari on Mac OS.
      # { icon: "favicon-16x16.png" },                                    # The classic favicon, displayed in the tabs.
      { icon: "favicon.png", size: "16x16" },                           # The classic favicon, displayed in the tabs.
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },         # Used by IE, and also by some other browsers if we are not careful.
      # { icon: "mstile-70x70.png", size: "70x70" },                      # For Windows 8 / IE11.
      # { icon: "mstile-144x144.png", size: "144x144" },
      # { icon: "mstile-150x150.png", size: "150x150" },
      # { icon: "mstile-310x310.png", size: "310x310" },
      # { icon: "mstile-310x150.png", size: "310x150" }
    ]
  }
end

# Requires installing image_optim extensions.
# Ref: https://github.com/toy/image_optim
# 1) `brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush`
# 2) Download pngout from http://www.jonof.id.au/kenutils
# 3) `cp pngout /usr/local/bin/pngout`
# Also, must be placed outside :build to ensure it occurs prior to other
# extensions below that are also triggered after build.
activate :imageoptim unless DEV

# Sync with AWS S3
activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = "dev.greatstories.org"#config[:base_host]
  s3_sync.region                     = "us-east-1"
  s3_sync.delete                     = true
  s3_sync.after_build                = true
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = "public-read"
  s3_sync.encryption                 = false
  s3_sync.version_bucket             = false
end

unless DEV
  activate :cdn do |cdn|
    cdn.cloudflare = {
      zone: config[:base_zone],
      base_urls: [config[:base_url]]
    }
    cdn.filter = /.*/
    cdn.after_build = true
  end
end
