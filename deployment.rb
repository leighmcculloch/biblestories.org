class Deployment
  attr_accessor :locales, :zone, :zone_short, :font_host, :features

  def initialize(development: false, locales:, zone:, zone_short:, font_host:, features: {})
    @development = development
    @locales = locales
    @zone = zone
    @zone_short = zone_short
    @font_host = font_host
    @features = features
  end

  def host
    "#{@development ? "dev." : ""}#{self.zone}"
  end

  def host_short
    "#{@development ? "dev." : ""}#{self.zone_short}"
  end

  def base_url_suffix(locale: nil)
    return "/#{locale.to_s}" if locale && self.locales.find_index(locale) > 0
    ""
  end

  def base_url(locale: nil)
    url = "http://#{self.host}"
    url << base_url_suffix(locale: locale)
    url
  end

  def base_url_short(locale: nil)
    url = "http://#{self.host_short}"
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
end