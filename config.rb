require 'lib/stories'
require 'lib/story'
require 'deployment'
require 'deployments'
require 'cache'
require 'builder'
require 'helpers/icon_helper'
helpers IconHelper

DEV = !!ENV['DEV']
set :development, DEV

DEPLOYMENTS = Deployments.new(deployments: [
  Deployment.new(
    locales: [:en, :"es-419"],
    locale_paths: { :"es-419" => "es" },
    zone: "biblestories.org",
    zone_short: "biblestories.org",
    aws_region: "us-east-1",
    font_host: "fonts.googleapis.com",
    development: DEV,
    features: {
      select_and_share: true,
      sitemap: true
    },
    deploys_to: :firebase,
  ),
  Deployment.new(
    locales: [:fr],
    zone: "recitsbibliques.com",
    zone_short: "recitsbibliques.com",
    aws_region: "eu-central-1",
    font_host: "fonts.googleapis.com",
    development: DEV,
    features: {
      select_and_share: true,
      sitemap: true
    },
    deploys_to: :s3,
  ),
  Deployment.new(
    locales: [:"pt-BR"],
    zone: "historiasdabiblia.com.br",
    zone_short: "historiasdabiblia.com.br",
    aws_region: "sa-east-1",
    font_host: "fonts.googleapis.com",
    development: DEV,
    features: {
      select_and_share: true,
      sitemap: true
    },
    deploys_to: :s3,
  ),
  Deployment.new(
    locales: [:"zh-Hans"],
    zone: "greatstoriesofthebible.cn",
    zone_short: "greatstoriesofthebible.cn",
    aws_region: "us-east-1",
    font_host: nil,
    development: DEV,
    features: {
      select_and_share: false,
      sitemap: true
    },
    deploys_to: :s3,
  )
].compact)
set :deployments, DEPLOYMENTS

DEPLOYMENT_ID = ENV['DEPLOYMENT'].to_i
DEPLOYMENT = DEPLOYMENTS[DEPLOYMENT_ID]
set :deployment, DEPLOYMENT

set :build_dir, "build/#{DEPLOYMENT_ID}"

set :ga_id, "UA-1756782-37"

# dir setup
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# i18n
activate :i18n, :langs => DEPLOYMENTS.locales
set :locales, DEPLOYMENTS.locales

# sitemap
ready do
  if settings.deployment.has_feature?(:sitemap)
    page "/sitemap.xml", :layout => false
  else
    ignore "/sitemap.xml"
  end
end

# favicons
favicons = {
  "_favicon.png" => [
    { icon: "favicon-196x196.png" },                                  # For Android Chrome M31+.
    { icon: "favicon-160x160.png" },                                  # For Opera Speed Dial (up to Opera 12; this icon is deprecated starting from Opera 15), although the optimal icon is not square but rather 256x160. If Opera is a major platform for you, you should create this icon yourself.
    { icon: "favicon-96x96.png" },                                    # For Google TV.
    { icon: "favicon-32x32.png" },                                    # For Safari on Mac OS.
    { icon: "favicon-16x16.png" },                                    # The classic favicon, displayed in the tabs.
    { icon: "favicon.png", size: "16x16" },                           # The classic favicon, displayed in the tabs.
    { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },         # Used by IE, and also by some other browsers if we are not careful.
  ],
  "_favicon-flat.png" => [
    { icon: "apple-touch-icon-152x152-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS7.
    { icon: "apple-touch-icon-144x144-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS6 or prior.
    { icon: "apple-touch-icon-120x120-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS7.
    { icon: "apple-touch-icon-114x114-precomposed.png" },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS6 or prior.
    { icon: "apple-touch-icon-76x76-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS7.
    { icon: "apple-touch-icon-72x72-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS6 or prior.
    { icon: "apple-touch-icon-60x60-precomposed.png" },               # Same as apple-touch-icon-57x57.png, for non-retina iPhone with iOS7.
    { icon: "apple-touch-icon-57x57-precomposed.png" },               # iPhone and iPad users can turn web pages into icons on their home screen. Such link appears as a regular iOS native application. When this happens, the device looks for a specific picture. The 57x57 resolution is convenient for non-retina iPhone with iOS6 or prior. Learn more in Apple docs.
    { icon: "apple-touch-icon-precomposed.png", size: "57x57" },      # Same as apple-touch-icon.png, expect that is already have rounded corners (but neither drop shadow nor gloss effect).
    { icon: "apple-touch-icon.png", size: "57x57" },                  # Same as apple-touch-icon-57x57.png, for "default" requests, as some devices may look for this specific file. This picture may save some 404 errors in your HTTP logs. See Apple docs
    { icon: "mstile-70x70.png", size: "70x70" },                      # For Windows 8 / IE11.
    { icon: "mstile-144x144.png", size: "144x144" },
    { icon: "mstile-150x150.png", size: "150x150" },
    { icon: "mstile-310x310.png", size: "310x310" },
    { icon: "mstile-310x150.png", size: "310x150" }
  ]
}

if DEV
  favicons = {
    "_favicon.png" => [
      { icon: "favicon.png", size: "16x16" },
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
    ]
  }
end


# building
sprockets.append_path File.join "#{root}", "bower_components"

compass_config do |config|
  config.output_style = :compressed
end

activate :autoprefixer do |config|
  config.browsers = ['> 0.1%', 'last 2 versions', 'Explorer >= 6']
  config.cascade  = false
  config.inline   = true
end

activate :inliner

configure :build do
  activate :minify_html do |html|
    html.remove_comments = false
    html.remove_http_protocol = false
  end
  activate :minify_css
  activate :minify_javascript
  if DEPLOYMENT.gzip
    activate :gzip, :exts => [".js", ".css", ".html", ""]
  end
  activate :asset_hash, :ignore => [/^(images|fonts)\//]
  activate :favicon_maker, :icons => favicons
end

# Requires installing image_optim extensions.
# Ref: https://github.com/toy/image_optim
# 1) `brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush`
# 2) Download pngout from http://www.jonof.id.au/kenutils
# 3) `cp pngout /usr/local/bin/pngout`
# Also, must be placed outside :build to ensure it occurs prior to other
# extensions below that are also triggered after build.
# activate :imageoptim unless DEV

# These configurations need to be in an after_configuration to allow i18n to be setup
# fully before generating the story pages, etc.
ignore 'story.html'
ignore 'why.html'
ignore 'api/stories.json'
after_configuration do
  # pages
  page_content_types = {}
  page_redirects = {}
  DEPLOYMENT.locales.each_with_index do |lang, index|
    I18n.locale = lang

    prefix = DEPLOYMENT.base_url_suffix(locale: lang) if index > 0

    # index page
    page("#{prefix}/index.html", :proxy => ("/index.html" if prefix), :content_type => "text/html", :locale => lang) { I18n.locale = lang }

    # 404 page
    page("#{prefix}/404.html", :proxy => ("/404.html" if prefix), :content_type => "text/html", :locale => lang, :locals => { :error => 404 }) { I18n.locale = lang }

    # why page
    why_proxy_path = "/why.html"
    why_page_path = "#{prefix}/#{I18n.t(:"why.url")}#{DEPLOYMENT.html_page_ext}"
    why_proxy_path = nil if why_proxy_path == why_page_path
    page(why_page_path, :proxy => why_proxy_path, :content_type => "text/html", :locale => lang) { I18n.locale = lang }
    page_content_types[why_page_path.sub(/^\//, "")] = "text/html"

    # each story page
    Stories.all_accounts.each do |story_account_id, account|
      page_path = "#{prefix}/#{account.short_url(locale: lang)}#{DEPLOYMENT.html_page_ext}"
      page(page_path, :proxy => "/story.html", :content_type => "text/html", :locals => { :story => account.story, :account => account }, :locale => lang) { I18n.locale = lang }
      page_content_types[page_path.sub(/^\//, "")] = "text/html"
    end

    # redirects for moved story pages
    data.redirects[I18n.locale].try(:each) { |from, to| redirect "/#{from}", "/#{to}" }

    # api
    page_path = "#{prefix}/api/stories"
    page(page_path, :proxy => "/api/stories.json", :content_type => "application/json", :locale => lang, :layout => false) { I18n.locale = lang }
    page_content_types[page_path.sub(/^\//, "")] = "application/json"

    I18n.locale = I18n.default_locale
  end

  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = DEPLOYMENT.host
    s3_sync.region                     = DEPLOYMENT.aws_region
    s3_sync.delete                     = DEV
    s3_sync.after_build                = DEPLOYMENT.deploys_to == :s3
    s3_sync.prefer_gzip                = true
    s3_sync.path_style                 = true
    s3_sync.reduced_redundancy_storage = DEV
    s3_sync.acl                        = "public-read"
    s3_sync.encryption                 = false
    s3_sync.version_bucket             = false
    s3_sync.content_types              = page_content_types
  end
end

activate :s3_redirect do |config|
  config.bucket                = DEPLOYMENT.host
  config.region                = DEPLOYMENT.aws_region
  config.after_build           = DEPLOYMENT.deploys_to == :s3

end

