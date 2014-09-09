require_relative "apis/biblesorg_api"
require_relative "apis/crossway_api"
require_relative "apis/digital_bible_platform_api"

class Apis
  LOCALE_TO_API_TEXT_MAP = {
      :en => CrosswayApi,
      :es => BiblesorgApi,
      :"zh-Hans" => BiblesorgApi,
  }
  LOCALE_TO_API_AUDIO_MAP = {
      :en => CrosswayApi,
      :es => DigitalBiblePlatformApi,
      :"zh-Hans" => DigitalBiblePlatformApi,
  }

  def self.get_text(bible_ref)
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      locale = I18n.default_locale
    end
    api = LOCALE_TO_API_TEXT_MAP[locale]
    return nil if api.nil?
    $cache.get_or_set("#{locale}_#{api.class.name}_#{bible_ref}_text") do
      api.get_text(bible_ref)
    end
  end

  def self.get_audio(bible_ref)
    if LOCALE_TO_API_AUDIO_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      locale = I18n.default_locale
    end
    api = LOCALE_TO_API_AUDIO_MAP[locale]
    return nil if api.nil?
    $cache.get_or_set("#{locale}_#{api.class.name}_#{bible_ref}_audio") do
      api.get_audio(bible_ref)
    end
  end

  def self.get_read_more(bible_ref)
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      locale = I18n.default_locale
    end
    api = LOCALE_TO_API_TEXT_MAP[locale]
    return nil if api.nil?
    api.get_read_more(bible_ref)
  end

end