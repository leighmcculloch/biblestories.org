class Deployment
  attr_accessor :locales, :locale_paths, :zone, :zone_short, :aws_region, :font_host, :features, :deploys_to

  def initialize(development: false, locales:, locale_paths: {}, zone:, zone_short:, aws_region:, font_host:, features: {}, deploys_to:)
    @development = development
    @locales = locales
    @locale_paths = locale_paths
    @zone = zone
    @zone_short = zone_short
    @aws_region = aws_region
    @font_host = font_host
    @features = features
    @deploys_to = deploys_to
  end

  def host
    "#{@development ? "dev." : ""}#{self.zone}"
  end

  def host_short
    "#{@development ? "dev." : ""}#{self.zone_short}"
  end

  def base_url_suffix(locale: nil)
    return "/#{self.locale_paths[locale] || locale}" if locale && self.locales.find_index(locale) > 0
    ""
  end

  def base_url(locale: nil)
    url = "#{protocol}://#{self.host}"
    url << base_url_suffix(locale: locale)
    url
  end

  def base_url_short(locale: nil)
    url = "#{protocol}://#{self.host_short}"
    url << base_url_suffix(locale: locale)
    url
  end

  def page_from(url:, locale: nil)
    url = url.sub(self.base_url(locale: locale), '')
    url = url.sub(self.base_url_suffix(locale: locale), '')
    url
  end

  def has_feature?(feature)
    self.features.key?(feature) && self.features[feature]
  end

  def protocol
    @development ? "http" : "https"
  end

  def html_page_ext
    return ".html" if @deploys_to == :firebase
  end

  def gzip
    @deploys_to == :s3
  end
end
