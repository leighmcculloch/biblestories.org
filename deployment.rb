class Deployment
  attr_accessor :locales, :zone, :zone_short

  def initialize(development: false, locales:, zone:, zone_short:)
    @development = development
    @locales = locales
    @zone = zone
    @zone_short = zone_short
  end

  def host
    "#{@development ? "dev." : ""}#{self.zone}"
  end

  def host_short
    "#{@development ? "dev." : ""}#{self.zone_short}"
  end

  def base_url(locale: nil)
    url = "http://#{self.host}"
    url << "/#{locale.to_s}" if locale && self.locales.find_index(locale) > 0
    url
  end

  def base_url_short(locale: nil)
    url = "http://#{self.host_short}"
    url << "/#{locale.to_s}" if locale && self.locales.find_index(locale) > 0
    url
  end
end