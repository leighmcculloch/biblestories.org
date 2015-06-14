require_relative "apis/biblesorg_api"
require_relative "apis/crossway_api"
require_relative "apis/digital_bible_platform_api"

class Apis
  LOCALE_TO_API_TEXT_MAP = {
      :"en" => CrosswayApi, # English
      :"zh-Hans" => BiblesorgApi, # Chinese Simplified
      :"es-419" => BiblesorgApi, # Spanish (Latin America)
      # :"es-419" => BiblesorgApi, # Spanish (Latin America)
      # :"fr" => BiblesorgApi, # French
      # :"pt" => BiblesorgApi, # Portuguese
      :"pt-BR" => BiblesorgApi, # Portuguese (Brazil)
  }
  LOCALE_TO_API_AUDIO_MAP = {
      :"en" => CrosswayApi,
      :"zh-Hans" => DigitalBiblePlatformApi,
      :"es-419" => DigitalBiblePlatformApi,
      # :"fr" => DigitalBiblePlatformApi,
  }

  def self.get_text(bible_ref)
    if LOCALE_TO_API_TEXT_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      warn "APIs `get_text`: No platform defined for locale #{I18n.locale}"
      return nil
    end
    api = LOCALE_TO_API_TEXT_MAP[locale]
    return nil if api.nil?
    get_cache(locale, api.name).get_or_set("#{locale}_#{api.class.name}_#{bible_ref}_text") do
      api.get_text(bible_ref)
    end
  end

  def self.get_audio(bible_ref)
    if LOCALE_TO_API_AUDIO_MAP.key?(I18n.locale)
      locale = I18n.locale
    else
      warn "APIs `get_audio`: No platform defined for locale #{I18n.locale}"
      return nil
    end
    api = LOCALE_TO_API_AUDIO_MAP[locale]
    return nil if api.nil?
    get_cache(locale, api.name).get_or_set("#{locale}_#{api.class.name}_#{bible_ref}_audio") do
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